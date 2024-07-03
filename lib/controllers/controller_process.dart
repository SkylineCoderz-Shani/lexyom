import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/ApiEndPoint.dart';
import '../models/process.dart';

class ProcessController extends GetxController {
  var process = Rxn<Process>(); // Rxn is used to handle null values
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProcessInfo();
  }

  Future<void> fetchProcessInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(AppEndPoint.getProcess),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = json.decode(response.body);
      log(data.toString());

      if (response.statusCode == 200) {
        process.value = Process.fromJson(data);
      } else {
        log(data.toString());
      }
    } catch (e) {
      log(e.toString());

    } finally {
      isLoading(false);
    }
  }


  Future<void> completeProcess(int processId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = '${AppEndPoint.baseUrl}/update-process';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'process_id': processId}),
      );
      final data = json.decode(response.body);

      log(jsonEncode(data)); // Ensure that the data is logged as a string

      if (response.statusCode == 200) {
        await fetchProcessInfo();
        Get.snackbar('Success', 'Process completed successfully');
      } else {
        log(jsonEncode(data)); // Log the response data as a string
        Get.snackbar('Error', 'Failed to complete process: ${response.body}');
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Failed to complete process: $e');
    } finally {
      // Ensure you handle the loading state appropriately if needed
      isLoading(false);
    }
  }}
