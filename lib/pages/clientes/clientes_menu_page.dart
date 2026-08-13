import 'package:flutter/material.dart';
import 'package:dynacontrol_app/pages/clientes/consulta_cliente_cnpj_page.dart';
import 'package:dynacontrol_app/pages/clientes/consulta_cliente_nome_page.dart';
class ClientesMenuPage extends StatelessWidget {
  const ClientesMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: const Text(
                  'Consultar por CNPJ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  'Localizar cliente pelo CNPJ',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
               builder: (context) => const ConsultaClienteCnpjPage(),
    ),
  );
},
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: const Text(
                  'Consultar por Nome',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  'Pesquisar clientes pelo nome',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
               onTap: () {
               Navigator.push(
               context,
               MaterialPageRoute(
              builder: (context) => const ConsultaClienteNomePage(),
              ),
              );
              },

              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person_add_alt_1),
                title: const Text(
                  'Cadastrar Cliente',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  'Incluir um novo cliente',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Vamos programar depois
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}