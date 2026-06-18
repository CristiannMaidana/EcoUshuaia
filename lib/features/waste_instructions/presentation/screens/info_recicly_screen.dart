import 'dart:convert';

import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/detail_material_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoReciclyScreen extends StatefulWidget {
  final String sectionId;

  const InfoReciclyScreen({super.key, required this.sectionId});

  @override
  State<InfoReciclyScreen> createState() => _InfoReciclyScreenState();
}

class _InfoReciclyScreenState extends State<InfoReciclyScreen> {
  static const _jsonPath =
      'lib/features/waste_instructions/presentation/data/info_recicly_data.json';

  late final Future<_GuideSectionData> _sectionFuture = _loadSection();

  Future<_GuideSectionData> _loadSection() async {
    final rawJson = await rootBundle.loadString(_jsonPath);
    final decoded = json.decode(rawJson) as Map<String, dynamic>;
    final sections = (decoded['sections'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>();

    Map<String, dynamic>? matchedSection;
    for (final section in sections) {
      if (section['id'] == widget.sectionId) {
        matchedSection = section;
        break;
      }
    }

    if (matchedSection == null) {
      throw Exception('No se encontró la sección ${widget.sectionId}.');
    }

    return _GuideSectionData.fromJson(matchedSection);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_GuideSectionData>(
      future: _sectionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No se pudo cargar la guía seleccionada.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final section = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 110,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Guia rapida',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  section.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  section.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: DetailMaterialCard(
              title: section.cardTitle,
              description: section.description,
              tag: section.tag,
              chips: section.chips,
              tips: section.tips,
              onBackPressed: () {
                Navigator.pop(context);
              },
              onViewContainersPressed: () {},
              primaryButtonText: section.ctaLabel,
            ),
          ),
        );
      },
    );
  }
}

class _GuideSectionData {
  final String title;
  final String subtitle;
  final String cardTitle;
  final String description;
  final String tag;
  final List<String> chips;
  final List<DetailMaterialTip> tips;
  final String ctaLabel;

  const _GuideSectionData({
    required this.title,
    required this.subtitle,
    required this.cardTitle,
    required this.description,
    required this.tag,
    required this.chips,
    required this.tips,
    required this.ctaLabel,
  });

  factory _GuideSectionData.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] as String?) ?? 'Guía';
    final summary = (json['summary'] as String?) ?? '';
    final intro = (json['intro'] as String?) ?? summary;
    final subtitle = (json['subtitle'] as String?) ?? summary;
    final type = (json['type'] as String?) ?? 'guide_detail';

    return _GuideSectionData(
      title: title,
      subtitle: subtitle,
      cardTitle: title,
      description: intro,
      tag: _buildTag(type),
      chips: _buildChips(json),
      tips: _buildTips(json),
      ctaLabel:
          (json['cta'] as Map<String, dynamic>?)?['label'] as String? ??
          'Ver más',
    );
  }

  static String _buildTag(String type) {
    return type
        .split('_')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  static List<String> _buildChips(Map<String, dynamic> json) {
    final chips = (json['chips'] as List<dynamic>? ?? [])
        .whereType<String>()
        .toList();
    if (chips.isNotEmpty) {
      return chips;
    }

    final materials = (json['materials'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) => item['name'] as String?)
        .whereType<String>()
        .take(5)
        .toList();
    if (materials.isNotEmpty) {
      return materials;
    }

    final quickItems = (json['quick_items'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) => item['label'] as String?)
        .whereType<String>()
        .take(5)
        .toList();
    if (quickItems.isNotEmpty) {
      return quickItems;
    }

    return const ['Guía'];
  }

  static List<DetailMaterialTip> _buildTips(Map<String, dynamic> json) {
    final cardTips = _mapTitleBodyList(json['cards']);
    if (cardTips.isNotEmpty) {
      return cardTips;
    }

    final notAllowedTips = _mapTitleBodyList(
      json['not_allowed_examples'],
      markPrefix: '!',
    );
    if (notAllowedTips.isNotEmpty) {
      return notAllowedTips;
    }

    final destinationTips = _mapTitleBodyList(json['destination_rules']);
    if (destinationTips.isNotEmpty) {
      return destinationTips;
    }

    final materialsTips = (json['materials'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => DetailMaterialTip(
            mark: '•',
            title: (item['name'] as String?) ?? 'Material',
            description:
                (item['short_description'] as String?) ??
                (item['destination_hint'] as String?) ??
                'Sin descripción disponible.',
          ),
        )
        .toList();
    if (materialsTips.isNotEmpty) {
      return materialsTips;
    }

    final specialItemsTips = (json['items'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) {
          final name = (item['name'] as String?) ?? 'Residuo especial';
          final description = (item['description'] as String?) ?? '';
          final whySpecial = (item['why_special'] as String?) ?? '';
          final doNotDo = (item['do_not_do'] as String?) ?? '';

          return DetailMaterialTip(
            mark: '!',
            title: name,
            description: [
              description,
              whySpecial,
              doNotDo,
            ].where((value) => value.isNotEmpty).join(' '),
          );
        })
        .toList();
    if (specialItemsTips.isNotEmpty) {
      return specialItemsTips;
    }

    final decisionTips = (json['decision_help'] as List<dynamic>? ?? [])
        .whereType<String>()
        .toList();
    if (decisionTips.isNotEmpty) {
      return List.generate(
        decisionTips.length,
        (index) => DetailMaterialTip(
          mark: '${index + 1}',
          title: 'Referencia ${index + 1}',
          description: decisionTips[index],
        ),
      );
    }

    final quickTips = (json['quick_items'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => DetailMaterialTip(
            mark: '•',
            title: (item['label'] as String?) ?? 'Acceso rápido',
            description: 'Material frecuente incluido en la guía rápida.',
          ),
        )
        .toList();
    if (quickTips.isNotEmpty) {
      return quickTips;
    }

    final commonMistakes = (json['common_mistakes'] as List<dynamic>? ?? [])
        .whereType<String>()
        .toList();
    if (commonMistakes.isNotEmpty) {
      return List.generate(
        commonMistakes.length,
        (index) => DetailMaterialTip(
          mark: '!',
          title: 'Error común ${index + 1}',
          description: commonMistakes[index],
        ),
      );
    }

    return const [
      DetailMaterialTip(
        mark: '•',
        title: 'Sin contenido',
        description: 'No hay información disponible para esta sección.',
      ),
    ];
  }

  static List<DetailMaterialTip> _mapTitleBodyList(
    dynamic source, {
    String? markPrefix,
  }) {
    final items = (source as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();

    return List.generate(items.length, (index) {
      final item = items[index];
      return DetailMaterialTip(
        mark: markPrefix ?? '${index + 1}',
        title: (item['title'] as String?) ?? 'Detalle',
        description: (item['body'] as String?) ?? 'Sin descripción disponible.',
      );
    });
  }
}
