class ContaPagar {
  final String vencimento;
  final String descricao;
  final double valor;
  final bool encontrado;

  ContaPagar({
    required this.vencimento,
    required this.descricao,
    required this.valor,
    required this.encontrado,
  });

  factory ContaPagar.fromJson(Map<String, dynamic> json) {
    return ContaPagar(
      vencimento: json['vencimento'] ?? '',
      descricao: json['descricao'] ?? '',
      valor: (json['valor'] ?? 0).toDouble(),
      encontrado: json['encontrado'] ?? false,
    );
  }
}