import Combine
import CoreLocation
import MapboxDirections
import MapboxNavigationCore
import MapboxNavigationUIKit
import UIKit

final class NavigationViewController: UIViewController {
    private let destinationCoordinate: CLLocationCoordinate2D
    private let destinationTitle: String?
    private let navigationManager = NavigationManager()

    private var cancellables = Set<AnyCancellable>()
    private var routeRequestTask: Task<Void, Never>?
    private var embeddedNavigationViewController: MapboxNavigationUIKit.NavigationViewController?
    private var hasRequestedRoute = false

    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Calculando ruta..."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(
        destinationCoordinate: CLLocationCoordinate2D,
        destinationTitle: String?
    ) {
        self.destinationCoordinate = destinationCoordinate
        self.destinationTitle = destinationTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupLoadingState()
        observeLocation()
        navigationManager.start()
    }

    deinit {
        routeRequestTask?.cancel()
    }

    private func setupLoadingState() {
        view.addSubview(loadingLabel)

        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            loadingLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Cerrar", for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    private func observeLocation() {
        navigationManager.$currentLocation
            .compactMap { $0 }
            .first()
            .sink { [weak self] _ in
                self?.requestRouteIfNeeded()
            }
            .store(in: &cancellables)
    }

    private func requestRouteIfNeeded() {
        guard !hasRequestedRoute else { return }
        hasRequestedRoute = true

        routeRequestTask = Task { [weak self] in
            guard let self else { return }

            do {
                let routes = try await navigationManager.calculateRoute(
                    to: destinationCoordinate,
                    title: destinationTitle
                )
                await MainActor.run {
                    self.presentNavigation(with: routes)
                }
            } catch {
                await MainActor.run {
                    self.loadingLabel.text = error.localizedDescription
                    print("Route error: \(error.localizedDescription)")
                }
            }
        }
    }

    private func presentNavigation(with routes: NavigationRoutes) {
        let navigationOptions = NavigationOptions(
            mapboxNavigation: navigationManager.mapboxNavigation,
            voiceController: navigationManager.routeVoiceController,
            eventsManager: navigationManager.eventsManager()
        )

        let navigationViewController = MapboxNavigationUIKit.NavigationViewController(
            navigationRoutes: routes,
            navigationOptions: navigationOptions
        )
        navigationViewController.delegate = self
        navigationViewController.routeLineTracksTraversal = true
        navigationViewController.floatingButtonsPosition = .topTrailing

        embeddedNavigationViewController = navigationViewController
        addChild(navigationViewController)
        navigationViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(navigationViewController.view, at: 0)

        NSLayoutConstraint.activate([
            navigationViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            navigationViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        navigationViewController.didMove(toParent: self)
        loadingLabel.removeFromSuperview()
    }

    @objc
    private func closeTapped() {
        dismiss(animated: true)
    }
}

extension NavigationViewController: MapboxNavigationUIKit.NavigationViewControllerDelegate {
    func navigationViewControllerDidDismiss(
        _ navigationViewController: MapboxNavigationUIKit.NavigationViewController,
        byCanceling canceled: Bool
    ) {
        dismiss(animated: true)
    }

    func navigationViewController(
        _ navigationViewController: MapboxNavigationUIKit.NavigationViewController,
        willRerouteFrom location: CLLocation?
    ) {
        print("Recalculando ruta...")
    }

    func navigationViewController(
        _ navigationViewController: MapboxNavigationUIKit.NavigationViewController,
        didFailToRerouteWith error: Error
    ) {
        print("Reroute error: \(error.localizedDescription)")
    }
}
