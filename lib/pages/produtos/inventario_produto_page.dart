import 'package:flutter/material.dart';
import 'package:dynacontrol_app/models/produto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynacontrol_app/services/produto_service.dart';


class InventarioProdutoPage extends StatefulWidget {
  final Produto produto;

  const InventarioProdutoPage({
    super.key,
    required this.produto,
  });

  @override
  State<InventarioProdutoPage> createState() =>
      _InventarioProdutoPageState();
}

class _InventarioProdutoPageState
    extends State<InventarioProdutoPage> {
  final TextEditingController _quantidadeController =
      TextEditingController();
      String mensagem = '';
      bool salvando = false;
      bool inventarioConcluido = false;

  @override
  void dispose() {
    _quantidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.produto.descricao,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text('Código: ${widget.produto.codigo}'),

            const SizedBox(height: 8),

            Text('Quantidade atual: ${widget.produto.qtde}'),

            const SizedBox(height: 24),

            TextField(
              controller: _quantidadeController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Nova quantidade',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            //----

            if (mensagem.isNotEmpty)
               Padding(
               padding: const EdgeInsets.only(bottom: 12),
               child: Text(
               mensagem,
             // style: TextStyle(
             //color: mensagem.startsWith('Quantidade válida')
             //? Colors.green
              //: Colors.red,
              //fontWeight: FontWeight.bold,
             //),
             ),
             ),

            //-------------------------------------------------------------
           if (!inventarioConcluido)
            SizedBox(
           width: double.infinity,
           child: ElevatedButton.icon(
           onPressed: salvando ? null : confirmarInventario,
           icon: salvando
           ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
            : const Icon(Icons.save),
          label: Text(
          salvando
             ? 'Confirmando...'
            : 'Confirmar inventário',
      ),
    ),
  ),

        if (inventarioConcluido)
         SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
          onPressed: () {
          Navigator.pop(context);
         },
         icon: const Icon(Icons.arrow_back),
         label: const Text('Voltar'),
         ),
         ),

          //-----------------------------------------------
          ],
        ),
      ),
    );
  }
 
Future<void> confirmarInventario() async {
  final textoQuantidade =
      _quantidadeController.text.trim().replaceAll(',', '.');

  if (textoQuantidade.isEmpty) {
    setState(() {
      mensagem = 'Digite a nova quantidade.';
    });
    return;
  }

  final novaQuantidade = double.tryParse(textoQuantidade);

  if (novaQuantidade == null) {
    setState(() {
      mensagem = 'Quantidade inválida.';
    });
    return;
  }

  if (novaQuantidade < 0) {
    setState(() {
      mensagem = 'A quantidade não pode ser negativa.';
    });
    return;
  }

  setState(() {
    salvando = true;
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

    final resultado = await ProdutoService.inventarioProduto(
      endpoint,
      widget.produto.codigo,
      novaQuantidade,
    );

    if (!mounted) return;

    setState(() {
      mensagem =
          '${resultado['mensagem'] ?? 'Inventário realizado com sucesso.'}\n'
          'Nova quantidade: ${resultado['nova_qtde']}';
          inventarioConcluido = true;
    });

    _quantidadeController.clear();
  } catch (erro) {
    if (!mounted) return;

    String textoErro = erro.toString();

    if (textoErro.startsWith('Exception: ')) {
      textoErro = textoErro.substring('Exception: '.length);
    }

    setState(() {
      mensagem = textoErro;
    });
  } finally {
    if (mounted) {
      setState(() {
        salvando = false;
      });
    }
  }
}


    }