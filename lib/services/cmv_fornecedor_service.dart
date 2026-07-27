import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dynacontrol_app/models/cmv_fornecedor_model.dart';


class CmvFornecedorService  {
  static const String apiKey = 'sk_live_dc_9f4a7c2e1b8d6f3a5c2e7d9b4f1a8c6';

  static Future<CmvFornecedor> buscarCmvFornecedor(
    String endpoint,
  ) async {
    final url = Uri.parse('$endpoint/cmvfornecedor');

    final resposta = await http.get(
      url,
      headers: {
        'X-API-Key': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (resposta.statusCode == 200) {
      final Map<String, dynamic> dados =
          jsonDecode(resposta.body) as Map<String, dynamic>;

      return CmvFornecedor.fromJson(dados);
    }

    throw Exception(
      'Erro ${resposta.statusCode}: ${resposta.body}',
    );
  }
}