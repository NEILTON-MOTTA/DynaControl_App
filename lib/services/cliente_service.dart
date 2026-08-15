import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dynacontrol_app/models/cliente_model.dart';

class ClienteService {
  static const String apiKey = 'sk_live_dc_9f4a7c2e1b8d6f3a5c2e7d9b4f1a8c6';

  static Future<Cliente?> buscarClientePorCnpj(
    String endpoint,
    String cnpj,
  ) async {
    final url = Uri.parse(
      '$endpoint/cliente_cnpj/$cnpj',
    );

    final resposta = await http.get(
      url,
      headers: {
        'X-API-Key': apiKey,
      },
    );

  print('URL CNPJ: $url');
  print('STATUS CNPJ: ${resposta.statusCode}');
  print('RESPOSTA CNPJ: ${resposta.body}');

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      return Cliente.fromJson(dados);
    }

    return null;
  }

  
  static Future<List<Cliente>> buscarClientePorNome(
  String endpoint,
  String nome,
) async {
  final url = Uri.parse(
    '$endpoint/cliente_nome/${Uri.encodeComponent(nome)}',
  );

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
        .map((item) => Cliente.fromJson(item))
        .toList();
  }

  return [];
}
static Future<String> cadastrarCliente(
  String endpoint,
  Map<String, dynamic> cliente,
) async {
  final url = Uri.parse('$endpoint/cliente');

  final resposta = await http.post(
    url,
    headers: {
      'X-API-Key': apiKey,
      'Content-Type': 'application/json',
    },
    body: jsonEncode(cliente),
  );

  final dados = jsonDecode(resposta.body);

  if (resposta.statusCode == 200 ||
      resposta.statusCode == 201) {
    return 'OK';
  }

  return dados['detail'] ?? 'Erro ao cadastrar cliente.';
}
}