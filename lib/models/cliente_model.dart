class Cliente {
  final String codigo;
  final String nome;
  final String fantasia;
  final String tipo;
  final int regimeTributario;
  final String cnpj;
  final String inscricao;
  final String? dataCad;
  final int ativo;
  final String? dataNasc;
  final String codMunicipio;
  final String tipoLogradouro;
  final String logradouro;
  final String numero;
  final String complemento;
  final String cep;
  final String uf;
  final String cidade;
  final String bairro;
  final String pontoRef;
  final String telefone1;
  final String telefone2;
  final String telefone3;
  final String telefone4;
  final String contato;
  final String email;
  final String obs;
  final String? desativarSistema;
  final String retorno;

  Cliente({
    required this.codigo,
    required this.nome,
    required this.fantasia,
    required this.tipo,
    required this.regimeTributario,
    required this.cnpj,
    required this.inscricao,
    required this.dataCad,
    required this.ativo,
    required this.dataNasc,
    required this.codMunicipio,
    required this.tipoLogradouro,
    required this.logradouro,
    required this.numero,
    required this.complemento,
    required this.cep,
    required this.uf,
    required this.cidade,
    required this.bairro,
    required this.pontoRef,
    required this.telefone1,
    required this.telefone2,
    required this.telefone3,
    required this.telefone4,
    required this.contato,
    required this.email,
    required this.obs,
    required this.desativarSistema,
    required this.retorno,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
  return Cliente(
    codigo: json['__codigo'] ?? '',
    nome: json['__nome'] ?? '',
    fantasia: json['__fantasia'] ?? '',
    tipo: json['__tipo'] ?? '',
    regimeTributario: json['__regimetributario'] ?? 0,
    cnpj: json['__cnpj'] ?? '',
    inscricao: json['__inscricao'] ?? '',
    dataCad: json['__datacad'],
    ativo: json['__ativo'] ?? 0,
    dataNasc: json['__datanasc'],
    codMunicipio: json['__codmunicipio'] ?? '',
    tipoLogradouro: json['__tipologradouro'] ?? '',
    logradouro: json['__logradouro'] ?? '',
    numero: json['__numero'] ?? '',
    complemento: json['__complemento'] ?? '',
    cep: json['__cep'] ?? '',
    uf: json['__uf'] ?? '',
    cidade: json['__cidade'] ?? '',
    bairro: json['__bairro'] ?? '',
    pontoRef: json['__ponto_ref'] ?? '',
    telefone1: json['__telefone1'] ?? '',
    telefone2: json['__telefone2'] ?? '',
    telefone3: json['__telefone3'] ?? '',
    telefone4: json['__telefone4'] ?? '',
    contato: json['__contato'] ?? '',
    email: json['__email'] ?? '',
    obs: json['__obs'] ?? '',
    desativarSistema: json['__desativar_sistema'],
    retorno: json['__retorno'] ?? '',
  );
}
}