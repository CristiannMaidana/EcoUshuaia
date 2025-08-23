class ServerException implements Exception {
  final int? statusCode;
  final String message;

  ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class ParseException implements Exception {
  final String message;
  
  ParseException(this.message);

  @override
  String toString() => 'ParseException: $message';
}