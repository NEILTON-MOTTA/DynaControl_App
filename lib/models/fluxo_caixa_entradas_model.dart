class FluxoCaixaEntrada {
  final String forma;
  final double valor;
  final bool encontrado;

  FluxoCaixaEntrada({
    required this.forma,
    required this.valor,
    required this.encontrado,
  });

  factory FluxoCaixaEntrada.fromJson(Map<String, dynamic> json) {
    return FluxoCaixaEntrada(
      forma: json['Forma'] ?? '',
      valor: (json['Valor'] ?? 0).toDouble(),
      encontrado: json['encontrado'] ?? false,
    );
  }
}