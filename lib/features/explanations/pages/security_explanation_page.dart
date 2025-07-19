import 'package:budgetbuddy_client/features/dashboard/pages/dashboard.dart';
import 'package:budgetbuddy_client/features/explanations/widgets/security_card.dart';
import 'package:flutter/material.dart';

class SecurityExplanationPage extends StatefulWidget {
  const SecurityExplanationPage({super.key});

  @override
  _SecurityExplanationPageState createState() =>
      _SecurityExplanationPageState();
}

class _SecurityExplanationPageState extends State<SecurityExplanationPage> {
  // ✅ Current page index
  int currentPage = 0;
  final PageController pageController = PageController();

  // ✅ Data for each card (now 4 pages)
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
    // ✅ NEW 4th page
    {
      'icon': 'assets/FoxReady.png', // Add your icon
      'title': 'Ready to Start',
      'description':
          'You\'re all set! Let\'s start managing your budget securely and efficiently.',
      'color': Color(0xFFFF6B35),
    },
  ];

  // ✅ Handle navigation when reaching the end
  void _handlePageChange(int index) {
    setState(() {
      currentPage = index;
    });

    // ✅ If user swipes past the last page, navigate to dashboard
    if (index >= securityFeatures.length) {
      _navigateToDashboard();
    }
  }

  // ✅ Navigate to dashboard
  void _navigateToDashboard() {
    // Or if you're using direct navigation:
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  }

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
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              scrollDirection: Axis.horizontal,
              itemCount:
                  securityFeatures.length +
                  1, // ✅ +1 for the swipe-to-navigate page
              onPageChanged: _handlePageChange, // ✅ Use the new handler
              itemBuilder: (context, index) {
                // ✅ If it's the last invisible page, navigate to dashboard
                if (index >= securityFeatures.length) {
                  // This page won't be visible, but triggers navigation
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _navigateToDashboard();
                  });
                  return Container(); // Empty container
                }

                final feature = securityFeatures[index];

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
          ),

          // ✅ Animated Progress Bar (now for 4 pages)
          Container(
            margin: EdgeInsets.only(top: 16, bottom: 16),
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  width:
                      MediaQuery.of(context).size.width *
                      ((currentPage + 1) /
                          securityFeatures
                              .length), // ✅ Progress based on 4 pages
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3),
                      bottomRight: Radius.circular(3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ✅ Page counter with swipe hint on last page
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: currentPage == securityFeatures.length - 1
                ? Text(
                    'Swipe to get started →',
                    key: ValueKey('swipe-hint'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Text(
                    '${currentPage + 1} of ${securityFeatures.length}',
                    key: ValueKey(currentPage),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
