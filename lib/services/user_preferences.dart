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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('requisition_id', requisitionId);
  }

  static Future<String?> getRequisitionId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('requisition_id');
  }

  static Future<void> setLinkedBankList(String bank) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> linkedbanks = prefs.getStringList('linked_banks') ?? [];
    if (!linkedbanks.contains(bank)) {
      linkedbanks.add(bank);
      await prefs.setStringList('linked_banks', linkedbanks);
    } else if (linkedbanks == []) {
      linkedbanks = [bank];
      await prefs.setStringList('linked_banks', linkedbanks);
    }
  }

  static Future<bool> isAnyBankLinked() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> linkedBanks = prefs.getStringList('linked_banks') ?? [];
    return linkedBanks.isNotEmpty;
  }

  static Future<void> setFirstTimeUse() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time_use', false);
  }

  static Future<bool> isFirstTimeUse() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('first_time_use') ?? true;
  }
}
