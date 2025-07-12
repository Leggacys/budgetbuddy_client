import 'dart:convert';
import 'dart:async';
import 'package:budgetbuddy_client/core/constants/constants.dart';
import 'package:budgetbuddy_client/features/banking/models/bank_model.dart';
import 'package:budgetbuddy_client/features/dashboard/pages/dashboard_page.dart';
import 'package:budgetbuddy_client/features/banking/services/nordigen_service.dart';
import 'package:budgetbuddy_client/core/services/deep_link_handler.dart';
import 'package:budgetbuddy_client/services/user_preferences.dart';
import 'package:budgetbuddy_client/utils/bank_linking_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BankListScreen extends StatefulWidget {
  const BankListScreen({super.key});

  @override
  State<BankListScreen> createState() => _BankListScreenState();
}

class _BankListScreenState extends State<BankListScreen> {
  StreamSubscription<String>? _nordigenSub;

  @override
  void initState() {
    super.initState();

    // Test server connection for debugging
    _testServerConnection();

    // Listen to global deep link handler for Nordigen callbacks
    _nordigenSub = DeepLinkHandler.instance.nordigenCallbackStream.listen((
      String ref,
    ) {
      _handleNordigenCallback(ref);
    });
  }

  @override
  void dispose() {
    _nordigenSub?.cancel();
    super.dispose();
  }

  void _handleNordigenCallback(String ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Received deep link with ref: $ref')),
    );

    // Debug stored data before sending to server
    _debugStoredData();

    if (ref.isEmpty) {
      debugPrint('❌ No ref parameter received in deep link');
      return;
    } else {
      final SharedPreferences prefs =
          SharedPreferences.getInstance() as SharedPreferences;

      final requisitionId = prefs.getString('requisitionId') ?? '';
      _sendRequisitionIdToServer(requisitionId);
    }
  }

  // Test method to check server connectivity
  Future<void> _testServerConnection() async {
    try {
      // Try multiple endpoints to see which ones exist
      final endpoints = [
        '/health',
        '/nordigen-add-requisition',
        '/nordigen_add_requisition',
        '/add-requisition',
        '/api/nordigen-add-requisition',
        '/',
      ];

      debugPrint('🔍 Testing server connectivity at $devServerUrl');

      for (final endpoint in endpoints) {
        try {
          final response = await http.get(Uri.parse('$devServerUrl$endpoint'));
          debugPrint('✅ $endpoint: ${response.statusCode}');
          if (response.statusCode != 404) {
            debugPrint(
              '   Response: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...',
            );
          }
        } catch (e) {
          debugPrint('❌ $endpoint: $e');
        }
      }
    } catch (e) {
      debugPrint('❌ Server not reachable: $e');
    }
  }

  // Debug method to check stored data
  Future<void> _debugStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint('📁 Stored SharedPreferences data:');
    debugPrint('  - selectedBankId: ${prefs.getString('selectedBankId')}');
    debugPrint('  - selectedBankName: ${prefs.getString('selectedBankName')}');
    debugPrint('  - user_email: ${prefs.getString('user_email')}');
    debugPrint('  - All keys: ${prefs.getKeys()}');
  }

  Future<void> _sendRequisitionIdToServer(String requisitionId) async {
    final prefs = await SharedPreferences.getInstance();
    final bankId = prefs.getString('selectedBankId');
    final bankName = prefs.getString('selectedBankName');
    UserPreferences.setLinkedBankList(bankName!);
    final email = prefs.getString('user_email');

    // Debug logging
    debugPrint('🔍 Sending requisition to server:');
    debugPrint('  - Requisition ID: $requisitionId');
    debugPrint('  - Bank ID: $bankId');
    debugPrint('  - Bank Name: $bankName');
    debugPrint('  - Email: $email');
    debugPrint('  - Server URL: $devServerUrl/nordingen_add_requisition');

    // Validate required data
    if (requisitionId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: No requisition ID received')),
      );
      return;
    }

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: User email not found. Please log in again.'),
        ),
      );
      return;
    }

    final url = Uri.parse('$devServerUrl/nordingen_add_requisition');

    // Prepare the request body
    final requestBody = {
      'requisition_id': requisitionId,
      'bank_id': bankId,
      'bank_name': bankName,
      'email': email,
    };

    // Debug: Print the exact JSON being sent
    final jsonBody = jsonEncode(requestBody);
    debugPrint('📤 Request body JSON:');
    debugPrint(jsonBody);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      debugPrint('📡 Server response:');
      debugPrint('  - Status Code: ${response.statusCode}');
      debugPrint('  - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Save successful requisition ID using helper
        await BankLinkingHelper.markBankAsLinked(requisitionId);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Bank linked successfully!')));

        // Navigate to dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false,
        );
      } else {
        // Try to parse error message from response
        String errorMessage =
            'Failed to send requisition ID: ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['error'] != null) {
            errorMessage += ' - ${errorData['error']}';
          } else if (errorData['message'] != null) {
            errorMessage += ' - ${errorData['message']}';
          } else {
            errorMessage += ' - ${response.body}';
          }
        } catch (e) {
          errorMessage += ' - ${response.body}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), duration: Duration(seconds: 5)),
        );
      }
    } catch (e) {
      debugPrint('❌ Error sending requisition: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> getRedirectLink(String bankId, String bankName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedBankId', bankId);
    await prefs.setString('selectedBankName', bankName);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Redirecting to $bankName')));

    final link = await NordigenService.createRequisition(bankId);
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banks')),
      body: FutureBuilder<List<Bank>>(
        future: NordigenService.getBanksList('ro'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No banks found'));
          } else {
            final banks = snapshot.data!;
            return ListView.builder(
              itemCount: banks.length,
              itemBuilder: (context, index) {
                final bankItem = banks[index];
                return ListTile(
                  leading: Image.network(
                    bankItem.logo,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.account_balance),
                  ),
                  title: Text(bankItem.name),
                  onTap: () {
                    getRedirectLink(bankItem.id, bankItem.name).catchError(
                      (error) => ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $error'))),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
