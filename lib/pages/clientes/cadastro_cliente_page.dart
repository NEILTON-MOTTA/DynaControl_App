import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dynacontrol_app/services/numerador_cliente_service.dart';
import 'package:dynacontrol_app/services/cliente_service.dart';

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key});

  @override
  State<CadastroClientePage> createState() =>
      _CadastroClientePageState();
}

class _CadastroClientePageState
    extends State<CadastroClientePage> {

  String codigoCliente = '';
  bool carregandoCodigo = true;
  String mensagem = '';
  final _nomeController = TextEditingController();
  final _fantasiaController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _inscricaoController = TextEditingController();

  final _cepController = TextEditingController();
  final _tipoLogradouroController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();
  final _codMunicipioController = TextEditingController();
  final _pontoRefController = TextEditingController();

  final _telefone1Controller = TextEditingController();
  final _telefone2Controller = TextEditingController();
  final _telefone3Controller = TextEditingController();
  final _telefone4Controller = TextEditingController();
  final _contatoController = TextEditingController();
  final _emailController = TextEditingController();
  final _obsController = TextEditingController();

  String? tipoCliente;

  @override
  void initState() {
    super.initState();
    carregarNovoCodigo();
  }
  @override
void dispose() {
  _nomeController.dispose();
  _fantasiaController.dispose();
  _cnpjController.dispose();
  _inscricaoController.dispose();

  _cepController.dispose();
  _tipoLogradouroController.dispose();
  _logradouroController.dispose();
  _numeroController.dispose();
  _complementoController.dispose();
  _bairroController.dispose();
  _cidadeController.dispose();
  _ufController.dispose();
  _codMunicipioController.dispose();
  _pontoRefController.dispose();

  _telefone1Controller.dispose();
  _telefone2Controller.dispose();
  _telefone3Controller.dispose();
  _telefone4Controller.dispose();
  _contatoController.dispose();
  _emailController.dispose();
  _obsController.dispose();

  super.dispose();
}

  Future<void> carregarNovoCodigo() async {
    final prefs = await SharedPreferences.getInstance();
    final endpoint = prefs.getString('endpoint');

    if (endpoint == null || endpoint.isEmpty) {
      setState(() {
        carregandoCodigo = false;
        mensagem = 'Endpoint da empresa não configurado.';
      });
      return;
    }

    final codigo =
        await NumeradorClienteService.incrementarCodigoCliente(
      endpoint,
    );

    if (!mounted) return;

    setState(() {
      carregandoCodigo = false;

      if (codigo == null || codigo.isEmpty) {
        mensagem = 'Não foi possível gerar o código do cliente.';
      } else {
        codigoCliente = codigo;
      }
    });
  }


Future<void> salvarCliente() async {

    /////////
    if (tipoCliente == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Selecione se o cliente é Pessoa Física ou Jurídica.',
      ),
    ),
  );
  return;
}
    ///
     if (_cnpjController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Informe o CNPJ/CPF do cliente.'),
      ),
    );
    return;
  }
  final prefs = await SharedPreferences.getInstance();
  final endpoint = prefs.getString('endpoint');

  

  if (endpoint == null || endpoint.isEmpty) {
    setState(() {
      mensagem = 'Endpoint da empresa não configurado.';
    });
    return;
  }


  
final hoje = DateTime.now();

final dataCadastro =
    '${hoje.day.toString().padLeft(2, '0')}/'
    '${hoje.month.toString().padLeft(2, '0')}/'
    '${hoje.year}';
  final dadosCliente = {
    'cli_codigo': codigoCliente,
    'cli_nome': _nomeController.text.trim().toUpperCase(),
    'cli_cnpj': _cnpjController.text.trim(),
    'cli_fantasia': _fantasiaController.text.trim().toUpperCase(),
    'cli_tipo': tipoCliente,
    'cli_regimetributario': 0,
    'cli_inscricao': _inscricaoController.text.trim(),
    'cli_datacad': dataCadastro,
    'cli_ativo': 1,
    'cli_datanasc': null,
    'cli_codmunicipio': _codMunicipioController.text.trim(),
    'cli_tipologradouro': _tipoLogradouroController.text.trim().toUpperCase(),
    'cli_logradouro': _logradouroController.text.trim().toUpperCase(),
    'cli_numero': _numeroController.text.trim(),
    'cli_complemento': _complementoController.text.trim().toUpperCase(),
    'cli_cep': _cepController.text.trim(),
    'cli_uf': _ufController.text.trim(),
    'cli_cidade': _cidadeController.text.trim().toUpperCase(),
    'cli_bairro': _bairroController.text.trim(),
    'cli_ponto_ref': _pontoRefController.text.trim().toUpperCase(),
    'cli_telefone1': _telefone1Controller.text.trim(),
    'cli_telefone2': _telefone2Controller.text.trim(),
    'cli_telefone3': _telefone3Controller.text.trim(),
    'cli_telefone4': _telefone4Controller.text.trim(),
    'cli_contato': _contatoController.text.trim(),
    'cli_email': _emailController.text.trim(),
    'cli_obs': _obsController.text.trim().toUpperCase(),
    'cli_desativar_sistema': 0,
  };
//################################

  final resultado = await ClienteService.cadastrarCliente(
  endpoint,
  dadosCliente,
);

if (!mounted) return;

if (resultado == 'OK') {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Cliente cadastrado com sucesso.'),
    ),
  );
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(resultado),
    ),
  );
}


}

//#######
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: carregandoCodigo
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : mensagem.isNotEmpty
                ? Center(
                    child: Text(mensagem),
                  )
                :  SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dados Principais',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          initialValue: codigoCliente,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Código',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          controller: _nomeController,
          decoration: const InputDecoration(
            labelText: 'Nome / Razão Social',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          controller: _fantasiaController,
          decoration: const InputDecoration(
            labelText: 'Nome Fantasia',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 12),
         //##########################################
        DropdownButtonFormField<String>(
           initialValue: tipoCliente,
           decoration: const InputDecoration(
           labelText: 'Tipo de Cliente',
           border: OutlineInputBorder(),
           ),
           hint: const Text('Selecione'),
           items: const [
           DropdownMenuItem(
           value: 'J',
          child: Text('Pessoa Jurídica'),
          ),
          DropdownMenuItem(
          value: 'F',
          child: Text('Pessoa Física'),
         ),
         ],
         onChanged: (valor) {
         setState(() {
         tipoCliente = valor;
         });
         },

        ),
        //##########################################

        const SizedBox(height: 12),

        TextFormField(
          controller: _cnpjController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'CNPJ / CPF',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          controller: _inscricaoController,
          decoration: const InputDecoration(
            labelText: 'Inscrição Estadual',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),

const Text(
  'Endereço',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _cepController,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    labelText: 'CEP',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _tipoLogradouroController,
  decoration: const InputDecoration(
    labelText: 'Tipo de Logradouro',
    hintText: 'Ex.: Rua, Avenida',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _logradouroController,
  decoration: const InputDecoration(
    labelText: 'Logradouro',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _numeroController,
  decoration: const InputDecoration(
    labelText: 'Número',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _complementoController,
  decoration: const InputDecoration(
    labelText: 'Complemento',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _bairroController,
  decoration: const InputDecoration(
    labelText: 'Bairro',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _cidadeController,
  decoration: const InputDecoration(
    labelText: 'Cidade',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _ufController,
  textCapitalization: TextCapitalization.characters,
  decoration: const InputDecoration(
    labelText: 'UF',
    hintText: 'Ex.: RJ',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _codMunicipioController,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    labelText: 'Código do Município',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _pontoRefController,
  decoration: const InputDecoration(
    labelText: 'Ponto de Referência',
    border: OutlineInputBorder(),
  ),
),
const SizedBox(height: 24),

const Text(
  'Contato',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _telefone1Controller,
  keyboardType: TextInputType.phone,
  decoration: const InputDecoration(
    labelText: 'Telefone 1',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _telefone2Controller,
  keyboardType: TextInputType.phone,
  decoration: const InputDecoration(
    labelText: 'Telefone 2',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _telefone3Controller,
  keyboardType: TextInputType.phone,
  decoration: const InputDecoration(
    labelText: 'Telefone 3',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _telefone4Controller,
  keyboardType: TextInputType.phone,
  decoration: const InputDecoration(
    labelText: 'Telefone 4',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _contatoController,
  decoration: const InputDecoration(
    labelText: 'Contato',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: const InputDecoration(
    labelText: 'E-mail',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

TextFormField(
  controller: _obsController,
  maxLines: 4,
  decoration: const InputDecoration(
    labelText: 'Observações',
    border: OutlineInputBorder(),
  ),
),


const SizedBox(height: 24),

   SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: salvarCliente,
    icon: const Icon(Icons.save),
    label: const Text('Salvar Cliente'),
  ),
),

    const SizedBox(height: 24),
      ],
    ),
  ),
      ),
    );
  }

}