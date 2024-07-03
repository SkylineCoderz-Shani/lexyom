import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import '../../constants/ApiEndPoint.dart';
import '../../controllers/home_controllers.dart';
import '../../models/plans.dart';
import '../../src/HomeScreen/home_screen.dart';
import '../authentication_APIServices/login_api_service.dart';

class ControllerGetPlans extends GetxController {
  RxList<Plan> plans = RxList([]);
  var isLoading = true.obs;
  RxString amount = "".obs;
  RxString planId = "".obs;
  RxString productId = "".obs;


  @override
  void onInit() {
    fetchPlans();
    super.onInit();
  }

  Future<void> fetchPlans() async {
    try {
      isLoading(true);
      String? token = await LoginAPIService.getToken();

      final response = await http.get(
        Uri.parse('${AppEndPoint.baseUrl}/get-plan'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      log(response.body);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['status']) {
          plans.value = List<Plan>.from(
              jsonResponse['plans'].map((x) => Plan.fromJson(x as Map<String, dynamic>))
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to fetch plans',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch plans: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar(
        'Error',
        'Failed to fetch plans: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
  Future<bool> subscribeToPlan(int planId, String paymentMethodId,String interval,) async {
    try {
      isLoading(true);
      String? token = await LoginAPIService.getToken();
      log("Payment Method Id:$paymentMethodId");

      final response = await http.post(
        Uri.parse('${AppEndPoint.createSubscription}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'plan_id': planId,
          'interval': interval ,
          // 'email': Get.find<ControllerHome>().user.value!.user.information.email,  // Use actual planId
          'paymentMethodId': paymentMethodId,  // Use actual paymentMethodId
        }),
      );
      log(response.body.toString());

      if (response.statusCode == 200) {
        Get.back();
        Get.offAll(HomeScreen());
        return true;
      } else {
        log('Failed to create subscription: ${response.statusCode}');
        Get.snackbar(
          'Error',
          'Failed to create subscription: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,

        );
        Get.back();
        return false;
      }
    } catch (e) {
      Get.back();
      log('Exception: $e');
      Get.snackbar(
        'Error',
        'Failed to create subscription: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> cancelSubscription(String planId) async {
    try {
      isLoading(true);
      String? token = await LoginAPIService.getToken();

      final response = await http.post(
        Uri.parse('${AppEndPoint.baseUrl}/cancel-subscription'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'plan_id': planId,
        }),
      );
      log(response.body.toString());

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'subscription cancelled') {
          Get.snackbar(
            'Success',
            'Subscription cancelled successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to cancel subscription',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to cancel subscription: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel subscription: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> changeSubscriptionPlan(String planId) async {
    try {
      isLoading(true);
      String? token = await LoginAPIService.getToken();

      final response = await http.post(
        Uri.parse('${AppEndPoint.baseUrl}/change-subscription'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'plan_id': planId,
        }),
      );
      log(response.body.toString());

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'subscription changed') {
          Get.snackbar(
            'Success',
            'Subscription plan changed successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to change subscription plan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to change subscription plan: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change subscription plan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
