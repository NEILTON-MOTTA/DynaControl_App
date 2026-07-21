import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dynacontrol_app/models/produto.dart';
import 'package:dynacontrol_app/services/produto_service.dart';

class ExibirlistaprodutosDescricao extends StatefulWidget {
  const ExibirlistaprodutosDescricao({super.key});

  @override
  State<ExibirlistaprodutosDescricao> createState() => _ExibirlistaprodutosDescricaoState();
}

class _ExibirlistaprodutosDescricaoState extends State<ExibirlistaprodutosDescricao> {
  final TextEditingController _pesquisaController = TextEditingController();

  List<Produto> produtos = [];
  bool carregando = false;
  String mensagem = '';

  int totalProdutos = 0;
  int offset = 0;
  final int limit = 50;
  

  @override
//////////////
///
///
///
///
//////////////

  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Produto'),
      ),
      body: Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      TextField(
        onSubmitted: (_) => carregarProdutos(),
        controller: _pesquisaController,
        decoration: const InputDecoration(
          labelText: 'Descrição do produto',
          border: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.search,
      ),

      const SizedBox(height: 12),

      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: carregando ? null : carregarProdutos,
          icon: const Icon(Icons.search),
          label: const Text('Pesquisar'),
        ),
      ),

      const SizedBox(height: 16),
      //
      //const Text('Os produtos encontrados aparecerão aqui.'),
       Text('Exibindo ${produtos.length} de $totalProdutos produtos'),
if (carregando)
  const CircularProgressIndicator(),

if (mensagem.isNotEmpty)
  Text(mensagem),

const SizedBox(height: 12),

Expanded(
  child: ListView.builder(
    itemCount: produtos.length,
    itemBuilder: (context, index) {
      final produto = produtos[index];

      return Card(
        child: ListTile(
          leading: const Icon(Icons.inventory_2),
          title: Text(produto.descricao),
            subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text('Código: ${produto.codigo}'),
            Text('Cód.Fabric.: ${produto.codfabricante}'),
            Text('Fabricante: ${produto.fabricante}'),
            Text('Quantidade: ${produto.qtde}'),
      ],
    ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.pop(context, produto);
          },
        ),
      );
    },
  ),
),
 
//inicio
if (produtos.length < totalProdutos)
  ElevatedButton.icon(
    onPressed: carregando ? null : carregarMaisProdutos,
    icon: const Icon(Icons.expand_more),
    label: Text(
      'Carregar mais (${produtos.length} de $totalProdutos)',
    ),
  )
else
  const Text(
    'Todos os produtos foram carregados.',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
//fim



//

      //
    ],
  ),
  
),

    );
    
  }




  
//////////////////////////////////////////////
//////////////////////////////////////////////
///
///Widget build(BuildContext context) 
///
  Future<void> carregarProdutos() async {
  final pesquisa = _pesquisaController.text.trim();

  if (pesquisa.isEmpty) {
    setState(() {
      mensagem = 'Digite a descrição do produto.';
    });
    return;
  }

  setState(() {
    carregando = true;
    mensagem = '';
    produtos.clear();
    offset = 0;
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

  final resultado = await ProdutoService.pesquisarDescricao(
    endpoint: endpoint,
    pesquisa: pesquisa,
    limit: limit,
    offset: 0,
  );

  setState(() {
    carregando = false;
    produtos = resultado.items;
    totalProdutos = resultado.count;
    offset = resultado.offset + resultado.items.length;

    if (produtos.isEmpty) {
      mensagem = 'Nenhum produto encontrado.';
       debugPrint('ABRIU SelecionarProdutoPage');
    }
  });
}
Future<void> carregarMaisProdutos() async {
  if (carregando || produtos.length >= totalProdutos) {
    return;
  }

  final pesquisa = _pesquisaController.text.trim();

  final prefs = await SharedPreferences.getInstance();
  final endpoint = prefs.getString('endpoint') ?? '';

  if (endpoint.isEmpty) {
    setState(() {
      mensagem = 'Endpoint da empresa não configurado.';
    });
    return;
  }

  setState(() {
    carregando = true;
  });

  final resultado = await ProdutoService.pesquisarDescricao(
    endpoint: endpoint,
    pesquisa: pesquisa,
    limit: limit,
    offset: offset,
  );

  setState(() {
    carregando = false;

    produtos.addAll(resultado.items);

    totalProdutos = resultado.count;

    offset = resultado.offset + resultado.items.length;
  });
}

}