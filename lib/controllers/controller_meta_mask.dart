import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../constants/ApiEndPoint.dart';
import '../src/HomeScreen/home_screen.dart';

class WalletController extends GetxController {
  var walletAddress = ''.obs;
  var contractAddress = ''.obs;
  var ownsNFT = false.obs;
  var balance = 0.obs;
  var isLoading = false.obs;
  var connectionError = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> checkNFT(String wallet) async {
    String? accessToken = await LoginAPIService.getToken();
    log(wallet);

    try {
      final response = await http.post(
        Uri.parse(AppEndPoint.getWallet),
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: {'wallet': wallet},
      );

      log("NFT Check: ${response.body}");

      if (response.statusCode == 200) {
        Get.offAll(HomeScreen());
      } else {
        final data = json.decode(response.body);
        log('Failed to check NFT: ${data['msg']}');
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(data['msg']),
          ),
        );
        Get.back();
      }
    } catch (e) {
      log('Exception: $e');
    }
  }
}
