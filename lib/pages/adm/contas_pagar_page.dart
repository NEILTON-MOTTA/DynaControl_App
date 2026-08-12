import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dynacontrol_app/models/contas_pagar_model.dart';
import 'package:dynacontrol_app/services/contas_pagar_service.dart';
import 'package:dynacontrol_app/utils/formatadores.dart';

class ContasPagarPage extends StatefulWidget {
  const ContasPagarPage({super.key});

  @override
  State<ContasPagarPage> createState() => _ContasPagarPageState();
}

class _ContasPagarPageState extends State<ContasPagarPage> {
  List<ContaPagar> contas = [];

  bool carregando = true;
  String mensagem = '';

  double get totalContas {
    return contas.fold(
      0.0,
      (total, conta) => total + conta.valor,
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
        await ContasPagarService.buscarContasPagar(endpoint);

    setState(() {
      contas = dados;
      carregando = false;

      if (contas.isEmpty) {
        mensagem = 'Nenhuma conta a pagar encontrada.';
      }
    });
  }

  String formatarData(String data) {
    final partes = data.split('-');

    if (partes.length != 3) {
      return data;
    }

    return '${partes[2]}/${partes[1]}/${partes[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas a Pagar'),
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
                            'Total a Pagar Hoje',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            formatarMoeda(totalContas),
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
                          itemCount: contas.length,
                          itemBuilder: (context, index) {
                            final conta = contas[index];

                            return Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.receipt_long,
                                ),
                                title: Text(
                                  conta.descricao,
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
                                      'Vencimento: ${formatarData(conta.vencimento)}',
                                    ),
                                    Text(
                                      formatarMoeda(conta.valor),
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