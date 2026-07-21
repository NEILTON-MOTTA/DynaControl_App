import 'package:flutter/material.dart';
import 'package:dynacontrol_app/pages/produtos/menu_produtos_page.dart';

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
              title: const Text('Produtos'),
              subtitle: const Text('Inventário de produtos'),
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
          const Card(
            child: ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Faturamento'),
              subtitle: Text('Relatórios de vendas'),
            ),
          ),
        ],
      ),
    );
  }
}