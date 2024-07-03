import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangePasswordWithOTP {
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("https://skorpio.codergize.com/api/check_otp"),
        body: jsonEncode({'email': email, 'otp': otp}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print("OTP Verified.");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Exception during OTP verification: $e');
    }
  }

  Future<bool> updatePassword(String email, String newPassword, String verifyPassword) async {
    try {
      final response = await http.post(
        Uri.parse("https://skorpio.codergize.com/api/change_password"),
        body: jsonEncode({'email': email, 'password': newPassword, 'verpassword': verifyPassword}),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 || (response.statusCode != 200 && responseData['data']['msg'] == "Password Reset Successful")) {
        print("Password Change Successful.");
        return true;
      } else {
        print("Password Change Failed. Unexpected response: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Password Change Failed. Exception: $e");
      return false;
    }
  }


}
