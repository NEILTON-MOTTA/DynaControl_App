import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dynacontrol_app/models/fluxo_caixa_entradas_model.dart';

class FluxoCaixaEntradasService {
  static const String apiKey =
      'sk_live_dc_9f4a7c2e1b8d6f3a5c2e7d9b4f1a8c6';

  static Future<List<FluxoCaixaEntrada>> buscarFluxoCaixaEntradas(
    String endpoint,
  ) async {

    final url = Uri.parse('$endpoint/fluxo_caixa_entradas');

    final resposta = await http.get(
      url,
      headers: {
        'X-API-Key': apiKey,
      },
    );

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      final List<dynamic> items = dados['items'] ?? [];

      return items
          .map((item) => FluxoCaixaEntrada.fromJson(item))
          .toList();
    }

    return [];
  }
}