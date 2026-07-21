import 'package:flutter/material.dart';
import 'consulta_produtos_page.dart';
import 'selecionar_produto_page.dart';
import 'package:dynacontrol_app/models/produto.dart';


class ProdutosPage  extends StatelessWidget {
  final bool modoInventario;

  const ProdutosPage({
    super.key,
    this.modoInventario = false,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Por Código'),
              subtitle: const Text('Pesquisar por código'),
              
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    
                    builder: (_) => ConsultaProdutosPage(
                  1,
                    modoInventario: modoInventario,
),
                  ),
                  
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Por Código Fabricante'),
              subtitle: const Text('Pesquisar por código Fabricante'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ConsultaProdutosPage(
                  2,
                    modoInventario: modoInventario,
),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Por Descrição'),
              subtitle: const Text('Pesquisar por descrição'),
              trailing: const Icon(Icons.arrow_forward_ios),
              //--------------------------
              onTap: () async {
               final Produto? produtoSelecionado =
               await Navigator.push<Produto>(
              context,
              MaterialPageRoute(
              builder: (_) => const SelecionarProdutoPage(),
           ),
           );

           if (produtoSelecionado == null || !context.mounted) {
           return;
           }

           Navigator.push(
           context,
          MaterialPageRoute(
          builder: (_) => ConsultaProdutosPage(
         3,
         produtoInicial: produtoSelecionado,
         modoInventario: modoInventario,
       ),
    ),
  );
},

              //-------------
            ),
          ),
   
        ],
      ),
    );
  }
}