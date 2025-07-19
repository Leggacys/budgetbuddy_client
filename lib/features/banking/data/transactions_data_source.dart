class Category {
  final String name;
  final double amount;

  Category({required this.name, required this.amount});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class Summary {
  final int netAmount;
  final int totalSpent;

  Summary({required this.netAmount, required this.totalSpent});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      netAmount: json['net_amount'] as int,
      totalSpent: json['total_spent'] as int,
    );
  }
}

class Transactions {
  final List<Category> categories;
  final String amount;
  final Summary summary;

  Transactions({
    required this.amount,
    required this.categories,
    required this.summary,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    final categoriesJson = json['categories'] as List<dynamic>;
    final categories = categoriesJson
        .map((category) => Category.fromJson(category as Map<String, dynamic>))
        .toList();

    final summaryJson = json['summary'] as Map<String, dynamic>;
    final summary = Summary.fromJson(summaryJson);

    return Transactions(
      amount: json['amount'] as String,
      categories: categories,
      summary: summary,
    );
  }
}
