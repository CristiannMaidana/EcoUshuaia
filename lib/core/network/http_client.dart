import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../config/env/env.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client _client;
  ApiClient(this._client);

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    final isAbsolute = path.startsWith('http://') || path.startsWith('https://');
    if (isAbsolute) return Uri.parse(path).replace(queryParameters: _stringifyQuery(query));
    
    final base = Env.BASE_URL.endsWith('/') ? Env.BASE_URL.substring(0, Env.BASE_URL.length - 1) : Env.BASE_URL;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$cleanPath').replace(queryParameters: _stringifyQuery(query));
  }

  Map<String, String>? _stringifyQuery(Map<String, dynamic>? query) {
    if (query == null) return null;
    return query.map((k, v) => MapEntry(k, v?.toString() ?? ''));
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final uri = _buildUri(path, query);
    try {
      final res = await _client.get(uri).timeout(Env.receiveTimeout);
      return _handleResponse(res);
    } on SocketException {
      throw NetworkException('Sin conexión a internet');
    } on HttpException {
      throw NetworkException('Error HTTP');
    } on FormatException {
      throw ParseException('Respuesta inválida del servidor');
    }
  }

  dynamic _handleResponse(http.Response res) {
    final code = res.statusCode;
    if (code >= 200 && code < 300) {
      if (res.body.isEmpty) return null;
      return json.decode(utf8.decode(res.bodyBytes));
    }
    
    String message = 'Error del servidor';
    try {
      final body = json.decode(utf8.decode(res.bodyBytes));
      message = body is Map && body['detail'] != null ? body['detail'].toString() : message;
    } catch (_) {}
    throw ServerException(message, statusCode: code);
  }
}