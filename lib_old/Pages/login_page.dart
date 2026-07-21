import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config_empresa_page.dart';
import 'principal_page.dart';
import 'package:flutter/services.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();
  bool carregandoLogin = false;
  String mensagemLogin = '';

  String empresaAtual = '';

  @override
  void initState() {
    super.initState();
    carregarEmpresa();
  }

  Future<void> carregarEmpresa() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      empresaAtual = prefs.getString('empresa') ?? 'Nenhuma empresa configurada';
    });
  }
Future<void> fazerLogin() async {
  final prefs = await SharedPreferences.getInstance();
  final usuario = usuarioController.text.trim();
  final senha = senhaController.text.trim();
  if (usuario.isEmpty || senha.isEmpty) {
    setState(() {
      mensagemLogin = 'Informe usuário e senha.';
    });
    return;
  }

  setState(() {
    carregandoLogin = true;
    mensagemLogin = '';
  });

  try {
    final prefs = await SharedPreferences.getInstance();
    final endpoint = prefs.getString('endpoint');

    if (endpoint == null || endpoint.isEmpty) {
      setState(() {
        mensagemLogin = 'Empresa não configurada.';
      });
      return;
    }

    final url = Uri.parse('$endpoint/valida_auth/$usuario/$senha');

    final resposta = await http.get(
      url,
      headers: {
        'X-API-Key': 'sk_live_dc_9f4a7c2e1b8d6f3a5c2e7d9b4f1a8c6',
      },
    );

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      if (dados['encontrou'] == 'true' || dados['encontrou'] == true) {
        final perfil = dados['perfil'] ?? 'USER';
        final nome = dados['nome'] ?? usuario;

        await prefs.setString( 'usuario_logado',  dados['usuario'] ?? usuario,   );

        await prefs.setString('nome_logado', nome,  );

        await prefs.setString( 'perfil_logado',  perfil,  );


        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PrincipalPage(
            perfil: perfil,
            nomeUsuario: nome,
            ),
          ),
        );
      } else {
        setState(() {
          mensagemLogin = 'Usuário ou senha inválidos.';
        });
      }
    } else {
      setState(() {
        mensagemLogin = 'Erro ${resposta.statusCode}: ${resposta.body}';
      });
    }
  } catch (e) {
    setState(() {
      mensagemLogin = 'Falha de conexão: $e';
    });
  } finally {
    setState(() {
      carregandoLogin = false;
    });
  }
}
  Future<void> trocarEmpresa() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('cnpj');
    await prefs.remove('empresa');
    await prefs.remove('endpoint');

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ConfigEmpresaPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DynaControl'),
      ),
      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Image.asset('assets/images/logo.png',      height: 140,  ),
              const SizedBox(height: 20),


const SizedBox(height: 10),

const Text(
  'DynaControl',
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

Card(
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      children: [
        const Text(
          'Empresa Atual',
          style: TextStyle(fontSize: 16),
        ),

        const SizedBox(height: 6),

        Text(
          empresaAtual,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
),

const SizedBox(height: 20),

            const SizedBox(height: 12),

           // Text(
            //  'Empresa atual: $empresaAtual',
            //  style: const TextStyle(fontSize: 16),
            //),

            const SizedBox(height: 30),

            TextField(
              controller: usuarioController,
              decoration: const InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
              onPressed: carregandoLogin ? null : fazerLogin,
              child: carregandoLogin
              ? const CircularProgressIndicator()
               : const Text('Entrar'),
               
              ),
            ),

            const SizedBox(height: 10),
            const SizedBox(height: 10),

             Text(
                 mensagemLogin,
                 style: const TextStyle(color: Colors.red),
                  ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: trocarEmpresa,
                child: const Text('Trocar Empresa'),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text('Fechar Aplicativo'),
              ),
            ),
          ],
        ),
      ),
    ),
     );
  }
}

