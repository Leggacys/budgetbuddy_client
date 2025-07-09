// Base model class for API responses
abstract class BaseModel {
  Map<String, dynamic> toJson();

  static T fromJson<T extends BaseModel>(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson must be implemented by subclass');
  }
}

// Example user model
class User extends BaseModel {
  final String id;
  final String email;
  final String? name;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    this.name,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// Example transaction model
class Transaction extends BaseModel {
  final String id;
  final String accountId;
  final double amount;
  final String description;
  final String category;
  final DateTime date;

  Transaction({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      accountId: json['account_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'amount': amount,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
    };
  }
}
