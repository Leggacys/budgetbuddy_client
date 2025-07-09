class Bank {
  final String id;
  final String name;
  final String bic;
  final String transactionTotalDays;
  final List<String> countries;
  final String logo;

  Bank({
    required this.id,
    required this.name,
    required this.bic,
    required this.transactionTotalDays,
    required this.countries,
    required this.logo,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    // Safely extract the 'countries' list as List<String>
    List<String> countries = [];
    if (json['countries'] is List) {
      countries = (json['countries'] as List)
          .where((e) => e != null)
          .map((e) => e.toString())
          .toList();
    }

    return Bank(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      bic: json['bic']?.toString() ?? '',
      transactionTotalDays: json['transaction_total_days']?.toString() ?? '',
      countries: countries,
      logo: json['logo']?.toString() ?? '',
    );
  }
}
