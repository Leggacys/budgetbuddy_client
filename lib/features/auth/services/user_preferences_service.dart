import 'package:budgetbuddy_client/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyEmail = 'user_email';

  static Future<void> setEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
  }

  static Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<void> saveRequisitionId(String requisitionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nordigen_requisition_id', requisitionId);
    logger.d('💾 UserPreferences: Saved requisition ID: $requisitionId');
  }

  static Future<String?> getRequisitionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nordigen_requisition_id');
  }

  static Future<void> clearRequisitionId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nordigen_requisition_id');
    logger.d('🗑️ UserPreferences: Cleared requisition ID');
  }

  static Future isFirstTimeUse() async {}
}
