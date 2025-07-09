import 'package:flutter/material.dart';

class TotalExpenses extends StatelessWidget {
  const TotalExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Expenses',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            '\$1234.56', // Replace with dynamic data
            style: TextStyle(fontSize: 32, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
