// Helper methods for bank linking status
import 'package:shared_preferences/shared_preferences.dart';

class BankLinkingHelper {
  // Reset bank linking status to force user back to bank selection
  static Future<void> resetBankLinking() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bank_linked');
    await prefs.remove('last_requisition_id');
    await prefs.remove('selectedBankId');
    await prefs.remove('selectedBankName');
  }

  // Check if user has linked a bank
  static Future<bool> isBankLinked() async {
    final prefs = await SharedPreferences.getInstance();
    final bankLinked = prefs.getBool('bank_linked') ?? false;
    final hasRequisitionId = prefs.getString('last_requisition_id');
    return bankLinked || hasRequisitionId != null;
  }

  // Mark bank as successfully linked
  static Future<void> markBankAsLinked(String requisitionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bank_linked', true);
    await prefs.setString('last_requisition_id', requisitionId);
  }

  // Get bank linking status info
  static Future<Map<String, String?>> getBankInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'bankId': prefs.getString('selectedBankId'),
      'bankName': prefs.getString('selectedBankName'),
      'requisitionId': prefs.getString('last_requisition_id'),
      'isLinked': (prefs.getBool('bank_linked') ?? false).toString(),
    };
  }
}
