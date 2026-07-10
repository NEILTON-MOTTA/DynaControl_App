class Produto {
  final String codigo;
  final String descricao;
  final String codfabricante;
  final String aplicacao;
  final String fabricante;
  final String segmento;
  final double qtde;
  final double preco1;
  final double preco2;
  final double preco3;
  final double preco4;
  final bool encontrado;

  Produto({
    required this.codigo,
    required this.descricao,
     required this.codfabricante,
    required this.aplicacao,
    required this.fabricante,
    required this.segmento,
    required this.qtde,
    required this.preco1,
    required this.preco2,
    required this.preco3,
    required this.preco4,
    required this.encontrado,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      codigo: json['codigo']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? '',
      aplicacao: json['aplicacao']?.toString() ?? '',
      fabricante: json['fabricante']?.toString() ?? '',
      codfabricante: json['codfabricante']?.toString() ?? '',
      segmento: json['segmento']?.toString() ?? '',
      qtde: double.tryParse(json['qtde'].toString()) ?? 0,
      preco1: double.tryParse(json['preco1'].toString()) ?? 0,
      preco2: double.tryParse(json['preco2'].toString()) ?? 0,
      preco3: double.tryParse(json['preco3'].toString()) ?? 0,
      preco4: double.tryParse(json['preco4'].toString()) ?? 0,
      encontrado: json['encontrado'] ?? false,
    );
  }
}