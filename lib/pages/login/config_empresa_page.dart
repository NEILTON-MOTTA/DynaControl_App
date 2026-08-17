import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'dart:convert';

class ConfigEmpresaPage extends StatefulWidget {
  const ConfigEmpresaPage({super.key});

  @override
  State<ConfigEmpresaPage> createState() => _ConfigEmpresaPageState();
}

class _ConfigEmpresaPageState extends State<ConfigEmpresaPage> {
  final cnpjController = TextEditingController();
  bool carregando = false;
  String mensagem = '';

  Future<void> localizarEmpresa() async {
    //final cnpj = cnpjController.text.replaceAll(RegExp(r'[^0-9]'), '');
    //final Buscaid = cnpjController.text.trim().toUpperCase();
    final cnpj = cnpjController.text.trim().toUpperCase();

   // if (cnpj.length != 14) {
   //   setState(() {
   //     mensagem = 'CNPJ inválido. Digite 14 números.';
   //   });
    //  return;
    //}

    setState(() {
      carregando = true;
      mensagem = '';
    });

    try {
      final url = Uri.parse('https://vps1.dynacomp.api.br/empresa_id/$cnpj');
      final resposta = await http.get(
  url,
  headers: {
    'X-API-Key': 'sk_live_dc_9f4a7c2e1b8d6f3a5c2e7d9b4f1a8c6',
  },
);
      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (dados['encontrado'] == true && dados['ativo'] == true) {
          final prefs = await SharedPreferences.getInstance();

          await prefs.setString('cnpj', dados['cnpj']);
          await prefs.setString('empresa', dados['empresa']);
          await prefs.setString('endpoint', dados['endpoint']);

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        } else {
          setState(() {
            mensagem = 'Empresa não encontrada ou inativa.';
          });
        }
     } else {
  setState(() {
    mensagem = 'Erro ${resposta.statusCode}: ${resposta.body}';
  });
}
    } catch (e) {
      setState(() {
        mensagem = 'Falha de conexão com o servidor.';
      });
    } finally {
      setState(() {
        carregando = false;
      });
    }
  }
@override
void dispose() {
  cnpjController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuração da Empresa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Informe o ID da empresa',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: cnpjController,
              //keyboardType: TextInputType.number,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'ID da Empresa',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: carregando ? null : localizarEmpresa,
                child: carregando
                    ? const CircularProgressIndicator()
                    : const Text('Localizar Empresa'),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              mensagem,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
