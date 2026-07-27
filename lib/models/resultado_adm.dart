import 'produto.dart';

class ResultadoProdutos {
  final int count;
  final int offset;
  final int limit;
  final List<Produto> items;

  ResultadoProdutos({
    required this.count,
    required this.offset,
    required this.limit,
    required this.items,
  });

  factory ResultadoProdutos.fromJson(Map<String, dynamic> json) {
    final lista = json['items'] as List? ?? [];

    return ResultadoProdutos(
      count: json['count'] ?? 0,
      offset: json['offset'] ?? 0,
      limit: json['limit'] ?? 50,
      items: lista
          .map<Produto>((item) => Produto.fromJson(item))
          .toList(),
    );
  }
}