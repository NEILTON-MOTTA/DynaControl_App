class CmvFornecedor {
  final double cmv;
  final double pagFornecedor;
  final double vendaacumulada;
  final bool encontrado;

  const CmvFornecedor({
    required this.cmv,
    required this.pagFornecedor,
    required this.vendaacumulada,
    required this.encontrado,
  });

  factory CmvFornecedor.fromJson(Map<String, dynamic> json) {
    return CmvFornecedor(
      cmv: (json['CMV'] as num?)?.toDouble() ?? 0,
      pagFornecedor: (json['Pagfornecedor'] as num?)?.toDouble() ?? 0,
      vendaacumulada: (json['venda'] as num?)?.toDouble() ?? 0,
      encontrado: json['encontrado'] == true,
    );
  }
}