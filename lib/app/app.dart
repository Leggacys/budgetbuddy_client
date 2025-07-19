import 'package:budgetbuddy_client/core/deep_link_handler.dart';
import 'package:budgetbuddy_client/features/root_page.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

class BudgetBuddyApp extends StatefulWidget {
  const BudgetBuddyApp({super.key});

  @override
  State<BudgetBuddyApp> createState() => _BudgetBuddyAppState();
}

class _BudgetBuddyAppState extends State<BudgetBuddyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
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

    // Handle deep links when app is launched from terminated state
    _handleInitialLink();
  }

  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handleIncomingLink(uri);
      }
    } catch (err) {
      debugPrint('❌ Error getting initial link: $err');
    }
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

  void _handleNordigenCallback(Uri uri) {
    final ref = uri.queryParameters['ref'];
    if (ref != null) {
      // Post the deep link data to be handled by the appropriate screen
      // This will be picked up by any listening BankListScreen
      DeepLinkHandler.instance.notifyNordigenCallback(ref);
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BudgetBuddy',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RootPage(),
    );
  }
}
