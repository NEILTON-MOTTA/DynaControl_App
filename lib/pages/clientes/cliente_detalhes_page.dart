import 'package:flutter/material.dart';
import 'package:dynacontrol_app/models/cliente_model.dart';

class ClienteDetalhesPage extends StatelessWidget {
  final Cliente cliente;

  const ClienteDetalhesPage({
    super.key,
    required this.cliente,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados do Cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cliente.nome,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Divider(),

                      Text('Código: ${cliente.codigo}'),
                      Text('Fantasia: ${cliente.fantasia}'),
                      Text('CNPJ/CPF: ${cliente.cnpj}'),
                      Text('Inscrição: ${cliente.inscricao}'),

                      const SizedBox(height: 16),

                      const Text(
                        'Endereço',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Divider(),

                      Text(
                        '${cliente.logradouro}, ${cliente.numero}',
                      ),
                      Text(
                        'Complemento: ${cliente.complemento}',
                      ),
                      Text(
                        'Bairro: ${cliente.bairro}',
                      ),
                      Text(
                        'Cidade: ${cliente.cidade} - ${cliente.uf}',
                      ),
                      Text(
                        'CEP: ${cliente.cep}',
                      ),
                      Text(
                        'Ponto de referência: ${cliente.pontoRef}',
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Contato',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Divider(),

                      Text(
                        'Contato: ${cliente.contato}',
                      ),
                      Text(
                        'Telefone 1: ${cliente.telefone1}',
                      ),
                      Text(
                        'Telefone 2: ${cliente.telefone2}',
                      ),
                      Text(
                        'Telefone 3: ${cliente.telefone3}',
                      ),
                      Text(
                        'Telefone 4: ${cliente.telefone4}',
                      ),
                      Text(
                        'E-mail: ${cliente.email}',
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Outras informações',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Divider(),

                      Text(
                        'Data cadastro: ${cliente.dataCad ?? ''}',
                      ),
                      Text(
                        'Observação: ${cliente.obs}',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}