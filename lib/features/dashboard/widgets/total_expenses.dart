// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TotalExpenses extends StatelessWidget {
  final double totalExpenses;
  final String currency;

  const TotalExpenses({
    super.key,
    required this.totalExpenses,
    this.currency = 'CHF',
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          width: 500,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text.rich(
                  TextSpan(
                    text: 'Total Expenses\n',
                    style: TextStyle(
                      color: Color.fromARGB(255, 7, 57, 49),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    children: [
                      TextSpan(
                        text: '$currency ${totalExpenses.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Color.fromARGB(255, 7, 57, 49),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
