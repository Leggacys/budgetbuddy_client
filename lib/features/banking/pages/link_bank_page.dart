import 'package:flutter/material.dart';
import 'bank_list_page.dart';

class LinkYourBankPage extends StatefulWidget {
  const LinkYourBankPage({super.key});

  @override
  State<LinkYourBankPage> createState() => _LinkYourBankPageState();
}

class _LinkYourBankPageState extends State<LinkYourBankPage> {
  Future<void> startLinkingBank(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BankListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 57, 49),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/Fox.png', width: 200, height: 200),
            SizedBox(height: 20),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Link your banks\n',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      height: 0.8,
                    ),
                  ),
                  TextSpan(
                    text: 'accounts to\n',
                    style: TextStyle(
                      fontSize: 38,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: 'budget buddy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Colors.white,
                      height: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Securely connect your bank\naccounts to manage your finances',
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 204, 204, 204),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 57, 132, 94),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => startLinkingBank(context),
                child: Text(
                  'Connect Bank Accounts',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
