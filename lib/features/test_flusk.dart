import 'package:http/http.dart' as http;

Future<void> testFlusk() async {
  final response = await http.get(Uri.parse("http://10.0.2.2:5000/hello"));
  final message = response.body;
  print(message);
}
