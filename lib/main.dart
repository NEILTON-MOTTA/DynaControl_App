import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/config_empresa_page.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final endpoint = prefs.getString('endpoint');

  runApp(
    DynaControlApp(
      telaInicial: endpoint == null
          ? const ConfigEmpresaPage()
          : const LoginPage(),
    ),
  );
}

class DynaControlApp extends StatelessWidget {
  final Widget telaInicial;

  const DynaControlApp({
    super.key,
    required this.telaInicial,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DynaControl',
      home: telaInicial,
    );
  }
}