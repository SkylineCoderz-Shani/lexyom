import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/controller_search_groups.dart';
import 'layouts/item_group_list.dart';

class ScreenSearchGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ControllerSearchGroups controllerSearchGroups =
        Get.put(ControllerSearchGroups());
    return Scaffold(
        appBar: AppBar(
          title: Text("Search Group"),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              // height: 45.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.withOpacity(.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: TextFormField(
                  onChanged: (value) async {
                    log(value);
                    await controllerSearchGroups.fetchGroupList(value);
                  },
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.only(top: 8.h),
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,

                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    border: InputBorder.none,
                    hintText: "Community Groups",
                  )),
            ),
          ),
        ),
        body: Obx(() => controllerSearchGroups.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : controllerSearchGroups.groupList.isNotEmpty
                ? ListView.builder(
                    itemCount: controllerSearchGroups.groupList.length,
                    itemBuilder: (context, index) {
                      final group = controllerSearchGroups.groupList[index];
                      return ItemGroupList(
                        group: group,
                      );
                    },
                  )
                : Center(child: Text("No Group Created Yet"))));
  }
}
