import 'dart:async';
import 'package:budgetbuddy_client/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';

const redirectUri = 'com.example.budgetbuddy://callback';
const clientId = 'sandbox-budgetbuddy-634d2f';
const clientSecret = '7a0460f8-1a59-4d22-bdac-34260e29e904';

Future<String> startOAuthFlow(BuildContext context) async {
  final authUrl = Uri.https('auth.truelayer-sandbox.com', '/', {
    'response_type': 'code',
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'scope':
        'info accounts balance cards transactions direct_debits standing_orders offline_access',
    'providers': 'uk-cs-mock uk-ob-all uk-oauth-all',
    'state': '123',
    'nonce': '456',
  });

  // Launch browser manually
  if (await canLaunchUrl(authUrl)) {
    await launchUrl(authUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $authUrl';
  }

  final completer = Completer<String>();
  final appLinks = AppLinks();

  StreamSubscription? sub;
  sub = appLinks.uriLinkStream.listen((Uri? uri) async {
    if (uri != null && uri.queryParameters['code'] != null) {
      final code = uri.queryParameters['code']!;
      logger.d('✅ Got code: $code');
      // ✅ Complete the completer with the code
      completer.complete(code);

      // ✅ Cancel the subscription after receiving
      await sub?.cancel();
    }
  });

  // Return the code via completer when ready
  return completer.future;
}
