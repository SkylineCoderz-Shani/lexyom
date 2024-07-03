import 'dart:convert';
import 'package:http/http.dart' as http;

Future<int?> fetchUserType(String token) async {
  try {
    var response = await http.get(
      Uri.parse('https://skorpio.codergize.com/api/login'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var userType = data['data']['user']['information']['usertype'];
      return int.tryParse(userType);
    } else {
      throw Exception('Failed to fetch usertype');
    }
  } catch (e) {
    print('Error fetching usertype: $e');
    throw Exception('Failed to fetch usertype');
  }
}
