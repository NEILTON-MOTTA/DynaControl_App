import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynacontrol_app/models/adm_model.dart';
import 'package:dynacontrol_app/services/adm_service.dart';
import 'package:dynacontrol_app/utils/formatadores.dart';

class AdmPage extends StatefulWidget {
  const AdmPage({super.key});

  @override
  State<AdmPage> createState() => _AdmPageState();
}

class _AdmPageState extends State<AdmPage> {
  List<Adm> vendasDiarias = [];

  bool carregando = false;
  String mensagem = '';

  @override
  void initState() {
    super.initState();
    buscarVendasDiarias();
  }

  Future<void> buscarVendasDiarias() async {
    setState(() {
      carregando = true;
      mensagem = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final endpoint = prefs.getString('endpoint');

      if (endpoint == null || endpoint.isEmpty) {
        setState(() {
          mensagem = 'Endpoint da empresa não configurado.';
        });
        return;
      }

      final resultado = await AdmService.buscarVendaDiaria(endpoint);

      if (!mounted) return;

      setState(() {
        vendasDiarias = resultado;

        if (vendasDiarias.isEmpty) {
          mensagem = 'Nenhuma venda encontrada.';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensagem = 'Erro ao buscar vendas diárias: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  String formatarData(String data) {
    try {
      final partes = data.split('-');

      if (partes.length != 3) {
        return data;
      }

      return '${partes[2]}/${partes[1]}/${partes[0]}';
    } catch (_) {
      return data;
    }
  }

  
  Widget linhaInformacao({
    required IconData icone,
    required String titulo,
    required String valor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            icone,
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget montarCard(Adm adm) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Text(
                  formatarData(adm.data),
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            linhaInformacao(
              icone: Icons.attach_money,
              titulo: 'Vendas',
              valor: formatarMoeda(adm.vendas),
            ),

            linhaInformacao(
              icone: Icons.inventory_2_outlined,
              titulo: 'Volume em qtde',
              valor: adm.volume.toStringAsFixed(0),
            ),

            linhaInformacao(
              icone: Icons.receipt_long,
              titulo: 'Quantidade de vendas',
              valor: adm.qtdeVendas.toString(),
            ),

            linhaInformacao(
              icone: Icons.show_chart,
              titulo: 'Ticket médio',
              valor: formatarMoeda(adm.ticketMedio),
            ),
            linhaInformacao(
              icone: Icons.trending_up,
              titulo: 'Markup',
              valor: '${adm.markup.toStringAsFixed(2)}%',
            ),
            linhaInformacao(
              icone: Icons.pie_chart,
              titulo: 'Margem',
              valor: '${adm.margem.toStringAsFixed(2)}%',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faturamento Diário'),
      ),
      body: RefreshIndicator(
        onRefresh: buscarVendasDiarias,
        child: carregando
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : mensagem.isNotEmpty
                ? ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const SizedBox(height: 100),
                      Center(
                        child: Text(
                          mensagem,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: vendasDiarias.length,
                    itemBuilder: (context, index) {
                      return montarCard(vendasDiarias[index]);
                    },
                  ),
      ),
    );
  }
}