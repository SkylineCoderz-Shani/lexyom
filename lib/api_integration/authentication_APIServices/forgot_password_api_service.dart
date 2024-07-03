import 'package:http/http.dart' as http;

class ForgotPasswordAPIService {
  static const String baseUrl = 'https://skorpio.codergize.com/api/forgot';

  static Future<bool> verifyEmail(String email) async {
    try {
      var response = await http.post(
        Uri.parse('email'),
        body: {'email': email},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
