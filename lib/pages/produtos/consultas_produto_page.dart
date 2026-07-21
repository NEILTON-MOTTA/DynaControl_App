import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynacontrol_app/pages/produtos/foto_produto_page.dart';
import 'package:dynacontrol_app/models/produto.dart';
import 'package:dynacontrol_app/pages/produtos/inventario_produto_page.dart';
import 'package:dynacontrol_app/services/produto_service.dart';


class ConsultasProdutoPage extends StatefulWidget {
  final int tipoConsulta;
  final Produto? produtoInicial;
  final bool modoInventario;

  const ConsultasProdutoPage(
    this.tipoConsulta, {
    super.key,
    this.produtoInicial,
    this.modoInventario = false,
  });




  @override
  State<ConsultasProdutoPage> createState() => _ConsultasProdutoPageState();
}

class _ConsultasProdutoPageState extends State<ConsultasProdutoPage> {
  final TextEditingController _pesquisaController = TextEditingController();

  Produto? produto;
  List<Produto> produtos = [];
  bool carregando = false;
  String mensagem = '';

  @override
void initState() {
  super.initState();
  produto = widget.produtoInicial;
  debugPrint('ABRIU ConsultasProdutoPage - tipo 1');
}
 

  Future<void> pesquisarProduto() async {
  if (widget.tipoConsulta == 1) {
    await pesquisarCodigoInterno();
  } else if (widget.tipoConsulta == 2) {
    await pesquisarCodigoFabricante();
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
    : widget.tipoConsulta == 2
        ? 'Consulta por Código Fabricante'
        : 'Consulta por Descrição';
   debugPrint(
  'ABRIU ConsultaProdutosPage - tipo ${widget.tipoConsulta}',
);
   final labelPesquisa = widget.tipoConsulta == 1
    ? 'Código Interno'
    : widget.tipoConsulta == 2
        ? 'Código Fabricante'
        : 'Descrição';

    return Scaffold(
      appBar: AppBar(
        title:  Text(tituloTela),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.tipoConsulta != 3) ...[
             TextField(
              controller: _pesquisaController,
              decoration: InputDecoration(
              labelText: labelPesquisa,
              border: const OutlineInputBorder(),
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
],

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
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: verFotos,
                              icon: const Icon(Icons.photo),
                              label: const Text('Ver Fotos'),
                             ),
                           ),
                           //------------------------------------------------------------------------------
                           if (widget.modoInventario)
                              SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                              onPressed: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (_) => InventarioProdutoPage(
                              produto: produto!,
                               ),
                               ),
                               );
                               },
                               icon: const Icon(Icons.inventory),
                               label: const Text('Fazer Inventário'),
                               ),
                             ),
                           //-----------------------------------
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

  ///////////////////////////////////////////////////
  
Future<void> pesquisarDescricao() async {
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
///////////////////////////////////
///
///
  // Aqui vamos chamar o ProdutoService no próximo passo.
final resultado = await ProdutoService.pesquisarDescricao(
  endpoint: endpoint,
  pesquisa: pesquisa,
);

debugPrint('Total encontrado: ${resultado.count}');
debugPrint('Itens retornados: ${resultado.items.length}');
//

setState(() {
  carregando = false;
  produtos = resultado.items;
  debugPrint('Produtos na tela: ${produtos.length}');

  if (produtos.isEmpty) {
    mensagem = 'Nenhum produto encontrado.';

  }
});
  //
}
void verFotos() {
  if (produto == null) {
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FotoProdutoPage(
        codigoProduto: produto!.codigo,
      ),
    ),
  );
}
 
}




    