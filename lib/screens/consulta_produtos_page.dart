import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/produto.dart';
import '../services/produto_service.dart';


class ConsultaProdutosPage extends StatefulWidget {
  final int tipoConsulta;

  const ConsultaProdutosPage(
    this.tipoConsulta, {
    super.key,
  });


  @override
  State<ConsultaProdutosPage> createState() => _ConsultaProdutosPageState();
}

class _ConsultaProdutosPageState extends State<ConsultaProdutosPage> {
  final TextEditingController _pesquisaController = TextEditingController();

  Produto? produto;
  bool carregando = false;
  String mensagem = '';
 

  Future<void> pesquisarProduto() async {
    
     if (widget.tipoConsulta == 1) {
          pesquisarCodigoInterno();
         }
     else if (widget.tipoConsulta == 2) {
         pesquisarCodigoFabricante(); 
      }
  }
  void verAplicacao() {
  if (produto == null) return;

  final textoAplicacao = produto!.aplicacao.trim();

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('Aplicação'),
        content: SingleChildScrollView(
          child: Text(
            textoAplicacao.isEmpty
                ? 'Aplicação não informada para este produto.'
                : textoAplicacao,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}
  String dinheiro(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
     final tituloTela = widget.tipoConsulta == 1
      ? 'Consulta por Código'
      : 'Consulta por Código Fabricante';

     final labelPesquisa = widget.tipoConsulta == 1
      ? 'Código Interno'
      : 'Código Fabricante';

    return Scaffold(
      appBar: AppBar(
        title:  Text(tituloTela),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pesquisaController,
              decoration:  InputDecoration(
                labelText: labelPesquisa,
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => pesquisarProduto(),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: carregando ? null : pesquisarProduto,
                icon: const Icon(Icons.search),
                label: const Text('Pesquisar'),
              ),
            ),

            const SizedBox(height: 16),

            if (carregando)
              const CircularProgressIndicator(),

            if (mensagem.isNotEmpty)
              Text(
                mensagem,
                style: const TextStyle(fontSize: 16),
              ),

            if (produto != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produto!.descricao,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text('Código: ${produto!.codigo}'),
                          Text('Fabricante: ${produto!.fabricante}'),
                          Text('Segmento: ${produto!.segmento}'),
                          Text('Estoque: ${produto!.qtde.toStringAsFixed(0)}'),

                          const Divider(height: 30),

                          Text('Preço 1: ${dinheiro(produto!.preco1)}'),
                          Text('Preço 2: ${dinheiro(produto!.preco2)}'),
                          Text('Preço 3: ${dinheiro(produto!.preco3)}'),
                          Text('Preço 4: ${dinheiro(produto!.preco4)}'),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: verAplicacao,
                              icon: const Icon(Icons.description),
                              label: const Text('Ver Aplicação'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

Future<void> pesquisarCodigoInterno() async {
   // consulta por código interno
   final pesquisa = _pesquisaController.text.trim();
   if (pesquisa.isEmpty) {
      setState(() {
        mensagem = 'Digite o código ';
      });
      return;
    }

    setState(() {
      carregando = true;
      mensagem = '';
      produto = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final endpoint = prefs.getString('endpoint') ?? '';

    if (endpoint.isEmpty) {
      setState(() {
        carregando = false;
        mensagem = 'Endpoint da empresa não configurado.';
      });
      return;
    }

    final resultado = await ProdutoService.pesquisarCodigoInterno(
      endpoint: endpoint,
      pesquisa: pesquisa,
    );

    setState(() {
      carregando = false;
      produto = resultado;
      mensagem = resultado == null ? 'Produto não encontrado.' : '';
    });
  }

  


Future<void> pesquisarCodigoFabricante() async {
   // consulta por código fabricante
   
   final pesquisa = _pesquisaController.text.trim();
   if (pesquisa.isEmpty) {
      setState(() {
        mensagem = 'Digite o código fabricante ';
      });
      return;
    }

    setState(() {
      carregando = true;
      mensagem = '';
      produto = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final endpoint = prefs.getString('endpoint') ?? '';

    if (endpoint.isEmpty) {
       setState(() {
        carregando = false;
        mensagem = 'Endpoint da empresa não configurado.';
      });
      return;
    }

    final resultado = await ProdutoService.pesquisarCodigoFabricante(
      endpoint: endpoint,
      pesquisa: pesquisa,
    );

    setState(() {
      carregando = false;
      produto = resultado;
      mensagem = resultado == null ? 'Produto não encontrado.' : '';
    });
  }
}






    