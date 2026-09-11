import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dynacontrol_app/services/cliente_service.dart';
import 'package:dynacontrol_app/pages/clientes/cliente_detalhes_page.dart';

class ConsultaClienteCodigoPage extends StatefulWidget {
  const ConsultaClienteCodigoPage({super.key});

  @override
  State<ConsultaClienteCodigoPage> createState() =>
      _ConsultaClienteCodigoPageState();
}

class _ConsultaClienteCodigoPageState
    extends State<ConsultaClienteCodigoPage> {

  final TextEditingController _codigoController =
      TextEditingController();

  bool carregando = false;
  String mensagem = '';

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> pesquisarCliente() async {
    final codigo = _codigoController.text.trim();

    if (codigo.isEmpty) {
      setState(() {
        mensagem = 'Digite o código do cliente.';
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
        await ClienteService.buscarClientePorCodigo(
      endpoint,
      codigo,
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
        title: const Text('Consulta Cliente por Código'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codigoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Código',
                hintText: 'Digite o código do cliente',
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