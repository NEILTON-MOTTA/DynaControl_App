import 'package:flutter/material.dart';
import 'produtos_page.dart';
import 'area_restrita_page.dart';
import 'package:dynacontrol_app/pages/login_page.dart';
// Depois vamos importar produtos_page.dart

class PrincipalPage extends StatelessWidget {
  final String perfil;
  final String nomeUsuario;

  const PrincipalPage({
    super.key,
    required this.perfil,
    required this.nomeUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 120,
          ),

          const SizedBox(height: 10),

          const Text(
            'DynaControl',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Bem-vindo, $nomeUsuario',
            style: const TextStyle(fontSize: 18),
          ),

          Text(
            'Perfil: $perfil',
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Produtos'),
              subtitle: const Text('Consulta de produtos'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (_) => const ProdutosPage(),
    ),
  );
},
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clientes'),
              subtitle: const Text('Cadastro e consulta de clientes'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Pedidos'),
              subtitle: const Text('Novo pedido e consulta de pedidos'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),

          if (perfil == 'ADMIN')
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Área Restrita'),
                subtitle: const Text(
                  'Acesso exclusivo para Administradores',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AreaRestritaPage(),
                    ),
                  );
                },
              ),
            ),

          Card(
           child: ListTile(
           leading: const Icon(Icons.exit_to_app),
           title: const Text('Sair'),
           subtitle: const Text('Voltar para a tela de login'),
           onTap: () {
           Navigator.pushAndRemoveUntil(
           context,
           MaterialPageRoute(
           builder: (_) => const LoginPage(),
           ),
           (route) => false,
           );
           },
           ),
  ),
        ],
      ),
    );
  }
}