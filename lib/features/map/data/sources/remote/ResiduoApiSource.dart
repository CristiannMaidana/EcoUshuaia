import 'dart:convert';
import 'package:eco_ushuaia/features/map/data/dtos/residuos_dto.dart';
import 'package:http/http.dart' as http;

class ResiduoApiSource {
  final http.Client _client;
  ResiduoApiSource(this._client);

  Future<List<ResiduosDto>> fetchResiduo() async {
    final resp = await _client.get(Uri.parse('http://127.0.0.1:8000/api/residuos/'));

    if (resp.statusCode != 200) {
      throw Exception('Error en la API: ${resp.statusCode}');
    }

    final list = (jsonDecode(resp.body) as List).cast<Map<String, dynamic>>();
    return list.map((j) => ResiduosDto.fromJson(j)).toList();
  }
}
