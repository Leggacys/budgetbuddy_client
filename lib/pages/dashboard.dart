import 'package:budgetbuddy_client/features/banking/pages/bank_list_page.dart';
import 'package:budgetbuddy_client/features/dashboard/widgets/total_expenses.dart';
import 'package:budgetbuddy_client/pages/dashboard/models/transaction_model.dart';
import 'package:budgetbuddy_client/pages/dashboard/services/transaction_service.dart';
import 'package:budgetbuddy_client/pages/dashboard/widgets/ring.dart';
import 'package:budgetbuddy_client/widgets/bottom_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<int> fetchData() async {
    List<Transaction> transactions =
        await TransactionService.fetchTransactions();
    double totalExpenses = TransactionService.calculateTotalExpenses(
      transactions,
    );
    return totalExpenses.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 57, 49),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text('Expenses'),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Transform.translate(
              offset: Offset(0, -7),
              child: Image.asset('assets/Fox.png', height: 40),
            ),
          ),
        ],
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 7, 57, 49),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 7, 57, 49),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Add Bank Account'),
              onTap: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BankListScreen()),
                  );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Data'),
              onTap: () {
                // Handle Delete Data action
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () async {
                await GoogleSignIn().signOut();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<int>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TotalExpenses(
                      totalExpenses: snapshot.data!.toDouble(),
                      currency: 'CHF',
                    ),
                    ColoredRing(
                      colors: [
                        Colors.red,
                        Colors.green,
                        Colors.blue,
                        Colors.yellow,
                      ],
                      percentages: [0.25, 0.25, 0.25, 0.25],
                    ),
                  ],
                ),
              );
            }
            // Default widget if none of the above conditions are met
            return SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          return BottomMenu(
            onMenuPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }
}
