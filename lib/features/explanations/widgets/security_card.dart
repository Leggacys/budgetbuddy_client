import 'package:flutter/material.dart';

class SecurityCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final Color cardColor;
  final Color iconColor;
  final Color titleColor;
  final Color descriptionColor;

  const SecurityCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
    this.cardColor = const Color(0xFF2196F3),
    this.iconColor = Colors.white,
    this.titleColor = Colors.white,
    this.descriptionColor = const Color(0xFFB3E5FC),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                iconPath,
                width: 250,
                height: 250,
                fit: BoxFit.contain,
                opacity: AlwaysStoppedAnimation(1),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
