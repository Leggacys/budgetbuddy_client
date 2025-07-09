// State management using ChangeNotifier (basic provider pattern)
import 'package:flutter/foundation.dart';

// Base provider class
abstract class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}

// Example: Auth provider
class AuthProvider extends BaseProvider {
  bool _isAuthenticated = false;
  String? _userEmail;

  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;

  Future<void> signIn(String email, String password) async {
    try {
      setLoading(true);
      clearError();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication logic
      if (email.isNotEmpty && password.isNotEmpty) {
        _isAuthenticated = true;
        _userEmail = email;
      } else {
        throw Exception('Invalid credentials');
      }

      setLoading(false);
    } catch (e) {
      setError(e.toString());
    }
  }

  void signOut() {
    _isAuthenticated = false;
    _userEmail = null;
    reset();
  }
}

// Example: Transaction provider
class TransactionProvider extends BaseProvider {
  List<Map<String, dynamic>> _transactions = [];

  List<Map<String, dynamic>> get transactions => _transactions;

  Future<void> fetchTransactions() async {
    try {
      setLoading(true);
      clearError();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      _transactions = [
        {
          'id': '1',
          'amount': -25.50,
          'description': 'Coffee Shop',
          'category': 'Food',
          'date': DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          'id': '2',
          'amount': -120.00,
          'description': 'Grocery Store',
          'category': 'Food',
          'date': DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          'id': '3',
          'amount': 2500.00,
          'description': 'Salary',
          'category': 'Income',
          'date': DateTime.now().subtract(const Duration(days: 3)),
        },
      ];

      setLoading(false);
    } catch (e) {
      setError(e.toString());
    }
  }

  void addTransaction(Map<String, dynamic> transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }
}
