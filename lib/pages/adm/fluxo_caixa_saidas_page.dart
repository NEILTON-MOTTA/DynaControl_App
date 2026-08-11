import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dynacontrol_app/models/fluxo_caixa_saidas_model.dart';
import 'package:dynacontrol_app/services/fluxo_caixa_saidas_service.dart';
import 'package:dynacontrol_app/utils/formatadores.dart';

class FluxoCaixaSaidasPage extends StatefulWidget {
  const FluxoCaixaSaidasPage({super.key});

  @override
  State<FluxoCaixaSaidasPage> createState() =>
      _FluxoCaixaSaidasPageState();
}

class _FluxoCaixaSaidasPageState extends State<FluxoCaixaSaidasPage> {
  List<FluxoCaixaSaida> saidas = [];

  bool carregando = true;
  String mensagem = '';

  double get totalSaidas {
    return saidas.fold(
      0.0,
      (total, saida) => total + saida.valor,
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
        await FluxoCaixaSaidasService.buscarFluxoCaixaSaidas(endpoint);

    setState(() {
      saidas = dados;
      carregando = false;

      if (saidas.isEmpty) {
        mensagem = 'Nenhuma saída encontrada.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluxo de Caixa - Saídas'),
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
                          leading: const Icon(
                            Icons.account_balance_wallet,
                          ),
                          title: const Text(
                            'Total das Saídas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            formatarMoeda(totalSaidas),
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
                          itemCount: saidas.length,
                          itemBuilder: (context, index) {
                            final saida = saidas[index];

                            return Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.money_off,
                                ),
                                title: Text(
                                  saida.descricao,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      saida.forma,
                                    ),
                                    Text(
                                      formatarMoeda(saida.valor),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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