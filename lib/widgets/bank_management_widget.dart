// Example widget showing bank management options for the dashboard
import 'package:budgetbuddy_client/pages/widgets/bank_list.dart';
import 'package:budgetbuddy_client/utils/bank_linking_helper.dart';
import 'package:flutter/material.dart';

class BankManagementWidget extends StatefulWidget {
  const BankManagementWidget({super.key});

  @override
  State<BankManagementWidget> createState() => _BankManagementWidgetState();
}

class _BankManagementWidgetState extends State<BankManagementWidget> {
  Map<String, String?> bankInfo = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBankInfo();
  }

  Future<void> _loadBankInfo() async {
    final info = await BankLinkingHelper.getBankInfo();
    setState(() {
      bankInfo = info;
      isLoading = false;
    });
  }

  Future<void> _linkDifferentBank() async {
    // Reset bank linking status
    await BankLinkingHelper.resetBankLinking();

    // Navigate to bank list
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BankListScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bank Account',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            if (bankInfo['bankName'] != null) ...[
              Text('Connected Bank: ${bankInfo['bankName']}'),
              const SizedBox(height: 8),
            ],

            if (bankInfo['requisitionId'] != null) ...[
              Text('Requisition ID: ${bankInfo['requisitionId']}'),
              const SizedBox(height: 8),
            ],

            Text(
              'Status: ${bankInfo['isLinked'] == 'true' ? 'Linked' : 'Not Linked'}',
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                ElevatedButton(
                  onPressed: _linkDifferentBank,
                  child: const Text('Link Different Bank'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: _loadBankInfo,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
