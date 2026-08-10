import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dynacontrol_app/models/fluxo_caixa_entradas_model.dart';
import 'package:dynacontrol_app/services/fluxo_caixa_entradas_service.dart';
import 'package:dynacontrol_app/utils/formatadores.dart';

class FluxoCaixaEntradasPage extends StatefulWidget {
  const FluxoCaixaEntradasPage({super.key});

  @override
  State<FluxoCaixaEntradasPage> createState() =>
      _FluxoCaixaEntradasPageState();
}

class _FluxoCaixaEntradasPageState extends State<FluxoCaixaEntradasPage> {
  List<FluxoCaixaEntrada> entradas = [];

  bool carregando = true;
  String mensagem = '';
  double get totalEntradas {
  return entradas.fold(
    0.0,
    (total, entrada) => total + entrada.valor,
  );
}

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    final endpoint = prefs.getString('endpoint');

    if (endpoint == null || endpoint.isEmpty) {
      setState(() {
        carregando = false;
        mensagem = 'Endpoint da empresa não configurado.';
      });

      return;
    }

    final dados =
        await FluxoCaixaEntradasService.buscarFluxoCaixaEntradas(endpoint);

    setState(() {
      entradas = dados;
      carregando = false;

      if (entradas.isEmpty) {
        mensagem = 'Nenhum recebimento encontrado.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluxo de Caixa - Entradas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: carregando
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : mensagem.isNotEmpty
                ? Center(
                    child: Text(mensagem),
                  )
                : Column(
       children: [
       Card(
          child: ListTile(
          leading: const Icon(Icons.account_balance_wallet),
          title: const Text(
            'Total das Entradas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            formatarMoeda(totalEntradas),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      const SizedBox(height: 12),

      Expanded(
        child: ListView.builder(
          itemCount: entradas.length,
          itemBuilder: (context, index) {
            final entrada = entradas[index];

            return Card(
              child: ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text(
                  entrada.forma,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  formatarMoeda(entrada.valor),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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