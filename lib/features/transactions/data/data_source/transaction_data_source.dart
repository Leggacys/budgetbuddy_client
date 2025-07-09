class Transaction {
  final String id;
  final DateTime timestamp;
  final String description;
  final String currency;
  final double amount;

  Transaction({
    required this.id,
    required this.timestamp,
    required this.description,
    required this.currency,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': id,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'amount': {'currency': currency, 'value': amount},
    };
  }
}
