import 'package:budgetbuddy_client/features/sent_code.dart';
import 'package:budgetbuddy_client/features/transactions/usercases/get_transactions.dart';
import 'package:flutter/material.dart';
import 'package:budgetbuddy_client/features/auth_true_layer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> startOathAndSendCode(BuildContext context) async {
    try {
      final code = await startOAuthFlow(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Code received: $code")));
      await SentCode(code);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> GetTransactions(BuildContext context) async {
    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fetching transactions...')));
      await getTransactions();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transactions fetched successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => startOathAndSendCode(context),
              child: Text("Login with true layer"),
            ),
            ElevatedButton(
              onPressed: () => GetTransactions(context),
              child: Text("Get Transactions"),
            ),
          ],
        ),
      ),
    );
  }
}
