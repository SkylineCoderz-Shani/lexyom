import 'package:get/get_connect.dart';

import '../model/GetCateogryModel.dart';

class ApiService extends GetConnect {
  static const String apiUrl = 'https://skorpio.codergize.com/api/get-category';

  Future<ApiResponse> fetchData() async {
    try {
      final response = await get(apiUrl);
      return ApiResponse.fromJson(response.body);
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }
}
