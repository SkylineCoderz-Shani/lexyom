import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_integration/payment_method_APIServices/controller_get_plans.dart';
import '../controllers/controller_group.dart';
import '../controllers/controller_process.dart';
import '../controllers/follow_controller.dart';

class ScreenTestApiResponse extends StatelessWidget {
ControllerGetPlans controllerGetPlans=Get.put(ControllerGetPlans());
GroupController groupController=Get.put(GroupController());
ProcessController processController=Get.put(ProcessController());
FollowController followController=Get.put(FollowController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Testing Api's"),
      ),
      body: Center(child: TextButton(onPressed: () {  }, child: Text("Test"),),),
    );
  }
}
