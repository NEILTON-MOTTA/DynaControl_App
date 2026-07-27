import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynacontrol_app/models/cmv_model.dart';
import 'package:dynacontrol_app/services/cmv_service.dart';

class CmvPage extends StatefulWidget {
  const CmvPage({super.key});

  @override
  State<CmvPage> createState() => _CmvPageState();
}

class _CmvPageState extends State<CmvPage> {
  Cmv? dadosCmv;

  bool carregando = false;
  String mensagem = '';

  @override
  void initState() {
    super.initState();
    buscarDados();
  }

  Future<void> buscarDados() async {
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

      final resultado = await CmvService.buscarCmvCompras(endpoint);

      if (!mounted) return;

      setState(() {
        dadosCmv = resultado;

        if (!resultado.encontrado) {
          mensagem = 'Dados não encontrados.';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensagem = 'Erro ao buscar CMV e compras: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  String formatarMoeda(double valor) {
    final negativo = valor < 0;
    final valorPositivo = valor.abs();

    final partes = valorPositivo.toStringAsFixed(2).split('.');

    final inteiro = partes[0];
    final decimal = partes[1];

    final buffer = StringBuffer();
    int contador = 0;

    for (int i = inteiro.length - 1; i >= 0; i--) {
      buffer.write(inteiro[i]);
      contador++;

      if (contador == 3 && i != 0) {
        buffer.write('.');
        contador = 0;
      }
    }

    final inteiroFormatado =
        buffer.toString().split('').reversed.join();

    final sinal = negativo ? '-' : '';

    return '$sinal R\$ $inteiroFormatado,$decimal';
  }

  Widget montarPainel({
    required IconData icone,
    required String titulo,
    required String valor,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              icone,
              size: 38,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget montarConteudo() {
    final dados = dadosCmv;

    if (dados == null) {
      return const SizedBox();
    }

    final diferenca = dados.cmv - dados.compras;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        montarPainel(
          icone: Icons.factory_outlined,
          titulo: 'Custo da Mercadoria Vendida',
          valor: formatarMoeda(dados.cmv),
        ),
        montarPainel(
          icone: Icons.shopping_cart_outlined,
          titulo: 'Compras',
          valor: formatarMoeda(dados.compras),
        ),
        montarPainel(
          icone: Icons.compare_arrows,
          titulo: 'Diferença entre CMV e compras',
          valor: formatarMoeda(diferenca),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CMV x Compras'),
      ),
      body: RefreshIndicator(
        onRefresh: buscarDados,
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
                : montarConteudo(),
      ),
    );
  }
}