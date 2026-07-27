class Adm {
  final String data;
  final double vendas;
  final double volume;
  final int qtdeVendas;
  final double ticketMedio;
  final bool encontrado;

  const Adm({
    required this.data,
    required this.vendas,
    required this.volume,
    required this.qtdeVendas,
    required this.ticketMedio,
    required this.encontrado,
  });

  factory Adm.fromJson(Map<String, dynamic> json) {
    return Adm(
      data: json['data']?.toString() ?? '',
      vendas: (json['vendas'] as num?)?.toDouble() ?? 0,
      volume: (json['volume'] as num?)?.toDouble() ?? 0,
      qtdeVendas: (json['qtde_vendas'] as num?)?.toInt() ?? 0,
      ticketMedio: (json['ticketmedio'] as num?)?.toDouble() ?? 0,
      encontrado: json['encontrado'] == true,
    );
  }
}