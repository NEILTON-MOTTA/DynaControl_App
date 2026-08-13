import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dynacontrol_app/models/cliente_model.dart';
import 'package:dynacontrol_app/services/cliente_service.dart';
import 'package:dynacontrol_app/pages/clientes/cliente_detalhes_page.dart';

class ConsultaClienteNomePage extends StatefulWidget {
  const ConsultaClienteNomePage({super.key});

  @override
  State<ConsultaClienteNomePage> createState() =>
      _ConsultaClienteNomePageState();
}

class _ConsultaClienteNomePageState
    extends State<ConsultaClienteNomePage> {

  final TextEditingController _nomeController =
      TextEditingController();

  List<Cliente> clientes = [];

  bool carregando = false;
  String mensagem = '';

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> pesquisarCliente() async {
    final nome = _nomeController.text.trim();

    if (nome.isEmpty) {
      setState(() {
        mensagem = 'Digite o nome do cliente.';
        clientes = [];
      });
      return;
    }

    setState(() {
      carregando = true;
      mensagem = '';
      clientes = [];
    });

    final prefs = await SharedPreferences.getInstance();
    final endpoint = prefs.getString('endpoint');

    if (endpoint == null || endpoint.isEmpty) {
      setState(() {
        carregando = false;
        mensagem = 'Endpoint da empresa não configurado.';
      });
      return;
    }

    final resultado =
        await ClienteService.buscarClientePorNome(
      endpoint,
      nome,
    );

    setState(() {
      clientes = resultado;
      carregando = false;

      if (clientes.isEmpty) {
        mensagem = 'Nenhum cliente encontrado.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta Cliente por Nome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do cliente',
                hintText: 'Digite parte do nome',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_search),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => pesquisarCliente(),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    carregando ? null : pesquisarCliente,
                icon: const Icon(Icons.search),
                label: const Text('Pesquisar'),
              ),
            ),

            const SizedBox(height: 16),

            if (carregando)
              const CircularProgressIndicator(),

            if (mensagem.isNotEmpty)
              Text(mensagem),

            if (!carregando && clientes.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = clientes[index];

                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.person,
                        ),
                        title: Text(
                          cliente.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Código: ${cliente.codigo}\n'
                          'CNPJ/CPF: ${cliente.cnpj}',
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                        onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => ClienteDetalhesPage(
                        cliente: cliente,
                        ),
                        ),
                       );
},
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}