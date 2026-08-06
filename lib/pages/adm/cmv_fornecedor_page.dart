import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynacontrol_app/models/cmv_fornecedor_model.dart';
import 'package:dynacontrol_app/services/cmv_fornecedor_service.dart';

class CmvFornecedorPage extends StatefulWidget {
  const CmvFornecedorPage({super.key});

  @override
  State<CmvFornecedorPage> createState() => _CmvFornecedorPageState();
}

class _CmvFornecedorPageState extends State<CmvFornecedorPage> {
  CmvFornecedor? dadosCmvFornecedor;
  

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

      final resultado =
    await CmvFornecedorService.buscarCmvFornecedor(endpoint);

      if (!mounted) return;

      setState(() {
        dadosCmvFornecedor = resultado;

        if (!resultado.encontrado) {
          mensagem = 'Dados não encontrados.';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensagem = 'Erro ao buscar CmvFornecedor e compras: $e';
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
    final dados = dadosCmvFornecedor;

    if (dados == null) {
      return const SizedBox();
    }

    final diferenca = dados.cmv - dados.pagFornecedor;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
         montarPainel(
          icone: Icons.factory_outlined,
          titulo: 'Vendas do mês',
          valor: formatarMoeda(dados.vendaacumulada),
        ),
        montarPainel(
          icone: Icons.factory_outlined,
          titulo: 'Custo da Mercadoria Vendida',
          valor: formatarMoeda(dados.cmv),
        ),
        montarPainel(
          icone: Icons.shopping_cart_outlined,
          titulo: 'Pagamento ao Fornecedor',
          valor: formatarMoeda(dados.pagFornecedor),
        ),
        montarPainel(
          icone: Icons.compare_arrows,
          titulo: 'Diferença entre pagamento ao fornecedor e compras',
          valor: formatarMoeda(diferenca),
        ),
      ],
    );
  }

  @override  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CMV x Pagamento Fornecedor'),
      ),      body: RefreshIndicator(
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