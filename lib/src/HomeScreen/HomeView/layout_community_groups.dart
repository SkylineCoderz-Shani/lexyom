import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/controller_get_group.dart';
import '../../views/layouts/item_group_list.dart';
import '../../views/screen_search_group.dart';

class LayoutCommunityGroups extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    ControllerGetGroup controllerGetGroup = Get.put(ControllerGetGroup());
    controllerGetGroup.fetchGroupList();

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.h,
          automaticallyImplyLeading: false,
          title: Container(
            // height: 40.h,
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
                readOnly: true,
                onTap: () {
                  Get.to(ScreenSearchGroups());
                },
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10),
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
        body: RefreshIndicator.adaptive(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            // Implement your refresh logic here
            await controllerGetGroup.fetchGroupList();
          },
          child: Obx(() => controllerGetGroup.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : controllerGetGroup.groupList.isNotEmpty
                  ? ListView.builder(
                      itemCount: controllerGetGroup.groupList.length,
                      itemBuilder: (context, index) {
                        final group = controllerGetGroup.groupList[index];
                        return ItemGroupList(
                          group: group,
                        );
                      },
                    )
                  : Center(child: Text("No Group Created Yet"))),
        ));
  }
}
