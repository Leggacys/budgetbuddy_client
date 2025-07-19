import 'package:budgetbuddy_client/features/banking/data/transactions_data_source.dart';
import 'package:budgetbuddy_client/features/banking/services/nordigen_service.dart';

class TransactionsService {
  static Future<List<Transactions>> getTransactions() async {
    final data = await NordingenService.getTransactions();

    if (data['transactions'] == null ||
        (data['transactions'] as List).isEmpty) {
      throw Exception('No transactions found for this email address');
    }

    final transactionsList = data['transactions'] as List<dynamic>;

    return transactionsList
        .map((transaction) => Transactions.fromJson(transaction))
        .toList();
  }
}
