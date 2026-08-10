import 'package:flutter/material.dart';
import 'package:dynacontrol_app/pages/produtos/menu_produtos_page.dart';
import 'package:dynacontrol_app/pages/adm/adm.dart';
import 'package:dynacontrol_app/pages/adm/cmv_page.dart';
import 'package:dynacontrol_app/pages/adm/cmv_fornecedor_page.dart';
import 'package:dynacontrol_app/pages/adm/fluxo_caixa_entradas_page.dart';


class AreaRestritaPage extends StatelessWidget {
  const AreaRestritaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área Restrita'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Inventário de produtos'),
              subtitle: const Text('Ajustar quantidade de produtos'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                   builder: (_) => const MenuprodutosPage(
                      modoInventario: true,
                    ),
                  ),
                );
              },
            ),
          ),
         Card(
          child: ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Faturamento'),
            subtitle: const Text('Relatório diário de vendas'),
            trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            ),
            onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => const AdmPage(),
            ),
            );
           },
          ),
         ),
          Card(
             child: ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Comparativo CMV X Compras'),
                subtitle: const Text(
                'Comparativo entre custo do produto vendido e compras',
      ),
                trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
                onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const CmvPage(),
                ),
                );
              },
            ),
          ),
           Card(
             child: ListTile(
               leading: const Icon(Icons.account_balance_wallet),
               title: const Text('CMV x Pagamento Fornecedor'),
               subtitle: const Text(
               'Comparativo entre CMV e pagamentos a fornecedores',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const CmvFornecedorPage(),
                ),
               );
              },
             ),
            ),
            Card(
             child: ListTile(
               leading: const Icon(Icons.attach_money),
               title: const Text('Fluxo de Caixa - (Entradas)'),
               subtitle: const Text(
               'Resumo de recebimentos',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const FluxoCaixaEntradasPage(),
                ),
               );
              },
             ),
            ),
            Card(
             child: ListTile(
               leading: const Icon(Icons.attach_money),
               title: const Text('Fluxo de Caixa - (saidas)'),
               subtitle: const Text(
               'lista de saidas do caixa',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const CmvFornecedorPage(),
                ),
               );
              },
             ),
            ),
            Card(
             child: ListTile(
               leading: const Icon(Icons.attach_money),
               title: const Text('Contas a Pagar'),
               subtitle: const Text(
               'Boletos a pagar na data de hoje',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const CmvFornecedorPage(),
                ),
               );
              },
             ),
            ),

        ],
      ),
    );
  }
}