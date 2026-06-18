import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto.dart';
import 'package:flutter/foundation.dart';

class ProdutoService {
  static const String apiKey =
      'sk_live_dc_9f4a7c2e1b8d6f3a5c2e7d9b4f1a8c6';

  static Future<Produto?> pesquisarCodigoInterno({
    required String endpoint,
    required String pesquisa,
  }) async {
    try {
      // Primeiro tenta por código interno
      var url = Uri.parse('$endpoint/produto_codigo/$pesquisa');

      var resposta = await http.get(
        url,
        headers: {
          'X-API-Key': apiKey,
        },
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        final produto = Produto.fromJson(dados);

        if (produto.encontrado) {
          return produto;
        }
      }

      // Se não encontrou, tenta por código fabricante
      url = Uri.parse('$endpoint/produto_codfabricante/$pesquisa');

      resposta = await http.get(
        url,
        headers: {
          'X-API-Key': apiKey,
        },
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        final produto = Produto.fromJson(dados);

        if (produto.encontrado) {
          return produto;
        }
      }

      return null;
    } catch (e) {
      debugPrint('Erro ao pesquisar produto: $e');
      return null;
    }
  }
  static Future<Produto?> pesquisarCodigoFabricante({
    required String endpoint,
    required String pesquisa,
  }) async {
    try {
      // Primeiro tenta por código interno
      var url = Uri.parse('$endpoint/produto_codigo/$pesquisa');

      var resposta = await http.get(
        url,
        headers: {
          'X-API-Key': apiKey,
        },
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        final produto = Produto.fromJson(dados);

        if (produto.encontrado) {
          return produto;
        }
      }

      // Se não encontrou, tenta por código fabricante
      url = Uri.parse('$endpoint/produto_codfabricante/$pesquisa');

      resposta = await http.get(
        url,
        headers: {
          'X-API-Key': apiKey,
        },
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        final produto = Produto.fromJson(dados);

        if (produto.encontrado) {
          return produto;
        }
      }

      return null;
    } catch (e) {
      debugPrint('Erro ao pesquisar produto: $e');
      return null;
    }
  }
}
