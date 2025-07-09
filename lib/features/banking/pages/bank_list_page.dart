import 'dart:convert';

import 'package:budgetbuddy_client/core/constants/app_constants.dart';
import 'package:budgetbuddy_client/features/banking/models/bank_model.dart';
import 'package:budgetbuddy_client/features/dashboard/pages/dashboard_page.dart';
import 'package:budgetbuddy_client/features/banking/services/nordigen_service.dart';
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
  @override
  void initState() {
    super.initState();

    // Test server connection for debugging
    _testServerConnection();

    // Check if there's a pending requisition to process
    _checkPendingRequisition();
  }

  Future<void> _checkPendingRequisition() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingRequisitionId = prefs.getString('nordigen_requisition_id');

    if (pendingRequisitionId != null && pendingRequisitionId.isNotEmpty) {
      debugPrint('� Found pending requisition ID: $pendingRequisitionId');

      // Clear the pending requisition to avoid duplicate processing
      await prefs.remove('nordigen_requisition_id');

      // Send to server
      _sendRequisitionIdToServer(pendingRequisitionId);
    }
  }

  Future<void> _sendRequisitionIdToServer(String requisitionId) async {
    final prefs = await SharedPreferences.getInstance();
    final bankId = prefs.getString('selectedBankId');
    final bankName = prefs.getString('selectedBankName');
    final email = prefs.getString('user_email');

    // Debug logging
    debugPrint('🔍 Sending requisition to server:');
    debugPrint('  - Requisition ID: $requisitionId');
    debugPrint('  - Bank ID: $bankId');
    debugPrint('  - Bank Name: $bankName');
    debugPrint('  - Email: $email');
    debugPrint('  - Server URL: $devServerUrl/nordigen-add-requisition');

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

    final url = Uri.parse('http://10.0.2.2:5000/nordigen-add-requisition');

    // Prepare the request body
    final requestBody = {
      'requisition_id': requisitionId,
      'bank_id': bankId ?? '',
      'bank_name': bankName ?? '',
      'email': email,
    };

    // Debug: Print the exact JSON being sent
    final jsonBody = jsonEncode(requestBody);
    debugPrint('📤 SENDING REQUEST TO SERVER:');
    debugPrint('  - URL: $url');
    debugPrint('  - Request Body JSON:');
    debugPrint('$jsonBody');
    debugPrint(
      '  - Requisition ID being sent: ${requestBody['requisition_id']}',
    );

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Requisition ID sent successfully')),
        );
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

    try {
      debugPrint('🔗 Getting redirect URL for bank: $bankName (ID: $bankId)');
      final link = await NordigenService.createRequisition(bankId);

      debugPrint('🌐 URL received from server: $link');
      debugPrint('🔍 URL type: ${link.runtimeType}');
      debugPrint('🔍 URL length: ${link.length}');
      debugPrint('🔍 URL starts with http: ${link.startsWith('http')}');

      final uri = Uri.parse(link);
      debugPrint('🔍 Parsed URI: $uri');
      debugPrint('🔍 URI scheme: ${uri.scheme}');
      debugPrint('🔍 URI host: ${uri.host}');

      if (await canLaunchUrl(uri)) {
        debugPrint('✅ URL can be launched, opening browser...');
        // Try different launch modes if one fails
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          debugPrint('✅ URL launched with externalApplication mode');
        } catch (e) {
          debugPrint(
            '⚠️ externalApplication failed, trying platformDefault: $e',
          );
          await launchUrl(uri, mode: LaunchMode.platformDefault);
          debugPrint('✅ URL launched with platformDefault mode');
        }
      } else {
        debugPrint('❌ Cannot launch URL: $link');
        // Try to launch anyway (sometimes canLaunchUrl gives false negatives)
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          debugPrint('✅ URL launched despite canLaunchUrl returning false');
        } catch (e) {
          throw 'Could not launch $link - URL may be invalid: $e';
        }
      }
    } catch (e) {
      debugPrint('❌ Error in getRedirectLink: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening bank link: $e'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  // Test method to check server connectivity
  Future<void> _testServerConnection() async {
    try {
      final response = await http.get(Uri.parse('$devServerUrl/health'));
      debugPrint('🏥 Server health check: ${response.statusCode}');
    } catch (e) {
      debugPrint('❌ Server not reachable: $e');
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
