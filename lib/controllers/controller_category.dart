import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/ApiEndPoint.dart';
import '../models/category.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs; // Observable list of categories
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token') ;
      isLoading(true);
      final response = await http.get(Uri.parse(AppEndPoint.getCategory,
      ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          }

      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']) {
          categories.value = List<Category>.from(data['category'].map((x) => Category.fromJson(x)));
        } else {
          Get.snackbar('Error', 'Failed to load categories');
        }
      } else {
        categories.value=[];
        log("Categories: ${response.body}");
      }
    } catch (e) {
      categories.value=[];
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
