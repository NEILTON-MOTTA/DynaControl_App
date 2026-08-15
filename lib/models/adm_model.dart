class Adm {
  final String data;
  final double vendas;
  final double volume;
  final int qtdeVendas;
  final double ticketMedio;
  final double markup;
  final double margem;
  final double cmv;
  final bool encontrado;

  const Adm({
    required this.data,
    required this.vendas,
    required this.volume,
    required this.qtdeVendas,
    required this.ticketMedio,
    required this.markup,
    required this.margem,
    required this.cmv,
    required this.encontrado,
  });

  factory Adm.fromJson(Map<String, dynamic> json) {
    return Adm(
      data: json['data']?.toString() ?? '',
      vendas: (json['vendas'] as num?)?.toDouble() ?? 0,
      volume: (json['volume'] as num?)?.toDouble() ?? 0,
      qtdeVendas: (json['qtde_vendas'] as num?)?.toInt() ?? 0,
      ticketMedio: (json['ticketmedio'] as num?)?.toDouble() ?? 0,
      markup: (json['markup'] as num?)?.toDouble() ?? 0,
      margem: (json['margem'] as num?)?.toDouble() ?? 0,
      cmv: (json['cmv'] as num?)?.toDouble() ?? 0,
      encontrado: json['encontrado'] == true,
    );
  }
}