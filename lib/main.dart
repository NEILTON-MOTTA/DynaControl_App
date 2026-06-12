import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final endpoint = prefs.getString('endpoint');

  runApp(DynaControlApp(
    telaInicial: endpoint == null ? const TelaConfigEmpresa() : const TelaLogin(),
  ));
}

class DynaControlApp extends StatelessWidget {
  final Widget telaInicial;

  const DynaControlApp({super.key, required this.telaInicial});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DynaControl',
      debugShowCheckedModeBanner: false,
      home: telaInicial,
    );
  }
}

class TelaConfigEmpresa extends StatefulWidget {
  const TelaConfigEmpresa({super.key});

  @override
  State<TelaConfigEmpresa> createState() => _TelaConfigEmpresaState();
}

class _TelaConfigEmpresaState extends State<TelaConfigEmpresa> {
  final cnpjController = TextEditingController();
  bool carregando = false;
  String mensagem = '';

  Future<void> localizarEmpresa() async {
    final cnpj = cnpjController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cnpj.length != 14) {
      setState(() {
        mensagem = 'CNPJ inválido. Digite 14 números.';
      });
      return;
    }

    setState(() {
      carregando = true;
      mensagem = '';
    });

    try {
      final url = Uri.parse('https://vps1.dynacomp.api.br/empresa_cnpj/$cnpj');
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
            MaterialPageRoute(builder: (_) => const TelaLogin()),
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
              'Informe o CNPJ da empresa',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: cnpjController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'CNPJ',
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

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
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
            builder: (context) => TelaMenuPrincipal(
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
      MaterialPageRoute(builder: (_) => const TelaConfigEmpresa()),
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
            const Icon(
  Icons.business,
  size: 60,
),

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

class TelaMenuPrincipal extends StatelessWidget {
  final String perfil;
  final String nomeUsuario;

  const TelaMenuPrincipal({
    super.key,
    required this.perfil,
    required this.nomeUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'DynaControl',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
           const SizedBox(height: 10),
            Text(
            'Bem-vindo, $nomeUsuario',
            style: const TextStyle(fontSize: 18),
                 ),

Text(
  'Perfil: $perfil',
  style: const TextStyle(fontSize: 14),
),
          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Produtos'),
              subtitle: const Text('Consulta de produtos'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaProdutos(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clientes'),
              subtitle: const Text('Cadastro e consulta de clientes'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Pedidos'),
              subtitle: const Text('Novo pedido e consulta de pedidos'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),

         if (perfil == 'ADMIN')
  Card(
    child: ListTile(
      leading: const Icon(Icons.lock),
      title: const Text('Área Restrita'),
      subtitle: const Text('Acesso exclusivo para Administradores'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TelaRestrita(),
          ),
        );
      },
    ),
  ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              subtitle: const Text('Voltar para a tela de login'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaLogin(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TelaProdutos extends StatelessWidget {
  const TelaProdutos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text('Consulta Produtos'),
              subtitle: Text('Pesquisar produtos no estoque'),
            ),
          ),
        ],
      ),
    );
  }
}

class TelaRestrita extends StatelessWidget {
  const TelaRestrita({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área Restrita'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Produtos'),
              subtitle: Text('Inventário de produtos'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Faturamento'),
              subtitle: Text('Relatórios de vendas'),
            ),
          ),
        ],
      ),
    );
  }
}