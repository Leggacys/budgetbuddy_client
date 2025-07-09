import 'package:budgetbuddy_client/constants.dart';
import 'package:budgetbuddy_client/pages/widgets/ring.dart';
import 'package:budgetbuddy_client/services/google_auth.dart';
import 'package:budgetbuddy_client/services/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<void> fetchData() async {
    final email = await UserPreferences.getEmail();
    final url = Uri.parse(
      '$devServerUrl/get_transactions?email=${Uri.encodeComponent(email ?? "")}',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Handle successful response
      logger.d(response.body);
    } else {
      // Handle error response
      logger.d('Failed to fetch data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 57, 49),
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text('Expanses'),
        ),
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 7, 57, 49),
      ),
      body: FutureBuilder<void>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ColoredRing(
              colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
              percentages: [0.25, 0.25, 0.25, 0.25],
            );
          }
          // Default widget if none of the above conditions are met
          return SizedBox.shrink();
        },
      ),
    );
  }
}
