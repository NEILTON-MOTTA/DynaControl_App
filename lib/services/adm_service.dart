import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/adm_model.dart';

class AdmService {
  static const String apiKey = 'sk_live_dc_9f4a7c2e1b8d6f3a5c2e7d9b4f1a8c6';

  static Future<List<Adm>> buscarVendaDiaria(String endpoint) async {
    final url = Uri.parse('$endpoint/venda_diaria');

    try {
      final resposta = await http.get(
        url,
        headers: {
          'X-API-Key': apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        final List<dynamic> items = dados['items'] ?? [];

        return items
            .map(
              (item) => Adm.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      throw Exception(
        'Erro ${resposta.statusCode}: ${resposta.body}',
      );
    } catch (e) {
      throw Exception('Erro ao buscar venda diária: $e');
    }
  }
}