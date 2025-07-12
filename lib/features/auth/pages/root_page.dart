import 'package:budgetbuddy_client/core/constants/constants.dart';
import 'package:budgetbuddy_client/features/dashboard/pages/home_page.dart';
import 'package:budgetbuddy_client/features/banking/pages/bank_list_page.dart';
// import 'package:budgetbuddy_client/features/auth/services/user_preferences_service.dart';
import 'package:budgetbuddy_client/pages/dashboard.dart';
import 'package:budgetbuddy_client/pages/security_explanation_page.dart';
import 'package:budgetbuddy_client/services/google_auth.dart';
import 'package:budgetbuddy_client/services/user_preferences.dart';
import 'package:budgetbuddy_client/utils/bank_linking_helper.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'login_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _loggedIn = false;
  bool _isLoading = false;
  bool _hasBankLinked = false;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _checkLoginAndBankStatus();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();

    // Handle deep links when app is already running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleIncomingLink(uri);
      },
      onError: (err) {
        debugPrint('❌ Error listening for deep links: $err');
      },
    );
  }

  void _handleIncomingLink(Uri uri) {
    debugPrint('🔗 Received deep link: $uri');

    // Check if this is a Nordigen callback (bank linking)
    if (uri.queryParameters.containsKey('ref')) {
      _handleNordigenCallback(uri);
    }
    // Handle other deep link patterns as needed
    else {
      debugPrint('🔗 Unhandled deep link pattern: $uri');
    }
  }

  void _handleNordigenCallback(Uri uri) async {
    final ref = uri.queryParameters['ref'];
    if (ref != null) {
      debugPrint('🔗 ROOT: Received Nordigen callback with ref: $ref');

      // Show feedback to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bank authentication completed!')),
        );
      }

      // Navigate to bank list page if not already there
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BankListScreen()),
        );
      }
    }
  }

  void _checkLoginAndBankStatus() async {
    setState(() {
      _isLoading = true;
    });

    // Check if user is logged in
    final email = await UserPreferences.getEmail();
    final isLoggedIn = email != null && email.isNotEmpty;

    // Check if user has linked a bank account
    bool hasBankLinked = false;
    if (isLoggedIn) {
      hasBankLinked = await BankLinkingHelper.isBankLinked();
    }

    setState(() {
      _loggedIn = isLoggedIn;
      _hasBankLinked = hasBankLinked;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> redirect(BuildContext context) async {
    final isFirstTime = await UserPreferences.isFirstTimeUse();
    logger.d('🔄 Redirecting user, first time use: $isFirstTime');
    if (isFirstTime) {
      if (context.mounted) {
        await UserPreferences.setFirstTimeUse();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SecurityExplanationPage()),
        );
      }
    } else {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        redirect(context);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return const LoginPage();
    }
  }
}
