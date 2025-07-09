import 'package:flutter/material.dart';

class TotalExpenses extends StatelessWidget {
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
                        text: 'CHF 1,200',
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
