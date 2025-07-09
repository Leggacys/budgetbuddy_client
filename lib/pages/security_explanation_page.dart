import 'package:budgetbuddy_client/pages/explanations/widgets/security_card.dart';
import 'package:flutter/material.dart';

class SecurityExplanationPage extends StatelessWidget {
  const SecurityExplanationPage({super.key});

  // ✅ Data for each card
  final List<Map<String, dynamic>> securityFeatures = const [
    {
      'icon': 'assets/FoxSecure.png',
      'title': 'Bank-Level Security',
      'description':
          'Your financial data is protected with the same security standards used by major banks worldwide.',
      'color': Color(0xFF1976D2),
    },
    {
      'icon': 'assets/FoxCantSee.png',
      'title': 'Data Encryption',
      'description': 'We can not see your password or any credentials',
      'color': Color(0xFF388E3C),
    },
    {
      'icon': 'assets/FoxDeleteData.png',
      'title': 'You are in Control',
      'description':
          'You can delete your data from our database whenever you want',
      'color': Color(0xFF7B1FA2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 57, 49),
      appBar: AppBar(
        title: Text('Security Information'),
        backgroundColor: Color.fromARGB(255, 7, 57, 49),
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: securityFeatures.length,
        itemBuilder: (context, index) {
          final feature = securityFeatures[index];

          // ✅ Use the SecurityCard component
          return SecurityCard(
            iconPath: feature['icon'],
            title: feature['title'],
            description: feature['description'],
            cardColor: feature['color'],
            iconColor: Colors.white,
            titleColor: Colors.white,
            descriptionColor: Colors.white70,
          );
        },
      ),
    );
  }
}
