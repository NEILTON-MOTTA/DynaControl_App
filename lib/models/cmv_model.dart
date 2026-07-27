class Cmv {
  final double cmv;
  final double compras;
  final bool encontrado;

  const Cmv({
    required this.cmv,
    required this.compras,
    required this.encontrado,
  });

  factory Cmv.fromJson(Map<String, dynamic> json) {
    return Cmv(
      cmv: (json['CMV'] as num?)?.toDouble() ?? 0,
      compras: (json['compras'] as num?)?.toDouble() ?? 0,
      encontrado: json['encontrado'] == true,
    );
  }
}