import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dynacontrol_app/services/cliente_service.dart';
import 'package:dynacontrol_app/pages/clientes/cliente_detalhes_page.dart';

class ConsultaClienteCnpjPage extends StatefulWidget {
  const ConsultaClienteCnpjPage({super.key});

  @override
  State<ConsultaClienteCnpjPage> createState() =>
      _ConsultaClienteCnpjPageState();
}

class _ConsultaClienteCnpjPageState
    extends State<ConsultaClienteCnpjPage> {

  final TextEditingController _cnpjController =
      TextEditingController();

  bool carregando = false;
  String mensagem = '';

  @override
  void dispose() {
    _cnpjController.dispose();
    super.dispose();
  }

  Future<void> pesquisarCliente() async {
    final cnpj = _cnpjController.text.trim();

    if (cnpj.isEmpty) {
      setState(() {
        mensagem = 'Digite o CNPJ.';
      });
      return;
    }

    setState(() {
      carregando = true;
      mensagem = '';
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
        await ClienteService.buscarClientePorCnpj(
      endpoint,
      cnpj,
    );

    if (!mounted) return;

    setState(() {
      carregando = false;
    });

    if (resultado == null) {
      setState(() {
        mensagem = 'Cliente não encontrado.';
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteDetalhesPage(
          cliente: resultado,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta Cliente por CNPJ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cnpjController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'CNPJ',
                hintText: 'Digite o CNPJ do cliente',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge_outlined),
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
          ],
        ),
      ),
    );
  }
}