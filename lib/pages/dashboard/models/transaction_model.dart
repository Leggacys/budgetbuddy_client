class Transaction {
  final String amount;

  Transaction({required this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(amount: json['transactionAmount']['amount']);
  }
}
