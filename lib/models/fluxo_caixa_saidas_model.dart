class FluxoCaixaSaida {
  final String descricao;
  final String forma;
  final double valor;
  final bool encontrado;

  FluxoCaixaSaida({
    required this.descricao,
    required this.forma,
    required this.valor,
    required this.encontrado,
  });

  factory FluxoCaixaSaida.fromJson(Map<String, dynamic> json) {
    return FluxoCaixaSaida(
      descricao: json['descricao'] ?? '',
      forma: json['forma'] ?? '',
      valor: (json['valor'] ?? 0).toDouble(),
      encontrado: json['encontrado'] ?? false,
    );
  }
}