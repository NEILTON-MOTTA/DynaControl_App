import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class FotoProdutoPage extends StatefulWidget {
  final String codigoProduto;

  const FotoProdutoPage({
    super.key,
    required this.codigoProduto,
  });

  @override
  State<FotoProdutoPage> createState() => _FotoProdutoPageState();
}

class _FotoProdutoPageState extends State<FotoProdutoPage> {
  int fotoAtual = 1;
  int totalFotos = 0;
  String? endpoint;
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    carregarEndpoint();
  }

  Future<void> carregarEndpoint() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      endpoint = prefs.getString('endpoint');
      
    });
    debugPrint(endpoint);
    carregarQuantidadeFotos();
  }

  //-----------------------------------------
  // CARREGA A QUANTIDADE DE FOTOS DO PRODUTO
  //-----------------------------------------

Future<void> carregarQuantidadeFotos() async {
  if (endpoint == null) {
    return;
  }

  final url = Uri.parse(
    '$endpoint/produto_numfotos/${widget.codigoProduto}',
  );

  final response = await http.get(
    url,
    headers: {
      'X-API-Key': 'sk_live_dc_9f4a7c2e1b8d6f3a5c2e7d9b4f1a8c6',
    },
  );

  if (response.statusCode == 200) {
    final dados = jsonDecode(response.body);

    setState(() {
      totalFotos = dados['qtde'] ?? 0;
    });

    debugPrint('Total de fotos: $totalFotos');
  }
}

 //-----------------------------------------
 //----------------------------------------- 

  @override
  Widget build(BuildContext context) {
    final urlFoto = endpoint == null
    ? ''
    : '$endpoint/produto_foto/${widget.codigoProduto}/$fotoAtual';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fotos do Produto'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          Text(
            'Produto: ${widget.codigoProduto}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          //'Aqui vamos exibir as fotos do produto.
 Text('Foto $fotoAtual de $totalFotos'),

const SizedBox(height: 12),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ElevatedButton.icon(
      onPressed: fotoAtual > 1
    ? () {
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    : null,
      icon: const Icon(Icons.arrow_back),
      label: const Text('Anterior'),
    ),

    const SizedBox(width: 12),

    ElevatedButton.icon(
      onPressed: fotoAtual < totalFotos
    ? () {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    : null,
      icon: const Icon(Icons.arrow_forward),
      label: const Text('Próxima'),
    ),
  ],
),

const SizedBox(height: 12),

if (totalFotos > 0)
SizedBox(
  height: 300,
  child: PageView.builder(
    controller: pageController,
    itemCount: totalFotos,
    onPageChanged: (index) {
      setState(() {
        fotoAtual = index + 1;
      });
    },
    itemBuilder: (context, index) {
      final numeroFoto = index + 1;

      final urlFotoPage =
          '$endpoint/produto_foto/${widget.codigoProduto}/$numeroFoto';

      return InteractiveViewer(
           minScale: 1.0,
           maxScale: 4.0,
           child: Image.network(
        urlFotoPage,
        headers: const {
          'X-API-Key': 'sk_live_dc_9f4a7c2e1b8d6f3a5c2e7d9b4f1a8c6',
        },
        fit: BoxFit.contain,

        loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? loadingProgress,
        ) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
           ),
      );
    },
  ),
)


else
  const Text('Este produto não possui fotos.'),
          
        ],
      ),
    );
  }
  
}
