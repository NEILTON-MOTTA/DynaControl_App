import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dynacontrol_app/models/cmv_model.dart';


class CmvService {
  static const String apiKey = 'sk_live_dc_9f4a7c2e1b8d6f3a5c2e7d9b4f1a8c6';

  static Future<Cmv> buscarCmvCompras(String endpoint) async {
    // Substitua pela rota exata da sua API.
    final url = Uri.parse('$endpoint/cmvcompras');

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

        return Cmv.fromJson(
          dados as Map<String, dynamic>,
        );
      }

      throw Exception(
        'Erro ${resposta.statusCode}: ${resposta.body}',
      );
    } catch (e) {
      throw Exception('Erro ao buscar CMV e compras: $e');
    }
  }
}