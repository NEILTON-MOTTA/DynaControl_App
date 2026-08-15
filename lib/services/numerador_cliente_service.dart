import 'dart:convert';

import 'package:http/http.dart' as http;

class NumeradorClienteService {
  static const String apiKey = 'sk_live_dc_9f4a7c2e1b8d6f3a5c2e7d9b4f1a8c6';

  static Future<String?> incrementarCodigoCliente(
    String endpoint,
  ) async {
    final url = Uri.parse(
      '$endpoint/numerador_cliente/incrementar',
    );

   final resposta = await http.put(url,
   headers: {
    'X-API-Key': apiKey,
           },
   );

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      return dados['novo_par_cliente_formatado'];
    }

    return null;
  }
}