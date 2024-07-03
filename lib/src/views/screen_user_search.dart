import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lexyom/src/views/screen_userProfileInfo.dart';
import '../../constants/ApiEndPoint.dart';
import '../../controllers/controller_search_users.dart';

class ScreenSearchUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ControllerSearchUsers controllerSearchUsers =
        Get.put(ControllerSearchUsers());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User',
        style: TextStyle(
          fontSize: 20.sp,
          fontFamily: "Inter",
          fontWeight: FontWeight.w500,
          color: Colors.black
        ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 40.sp,
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
                onChanged: (value) {
                  controllerSearchUsers.fetchUserList(value);
                },
                decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  // contentPadding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w
                  // ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  hintText: "Search Users",
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return controllerSearchUsers.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : controllerSearchUsers.userList.value.isEmpty
                      ? Center(
                          child: Text("No User"),
                        )
                      :  ListView.builder(
                itemCount: controllerSearchUsers.userList.length,
                itemBuilder: (context, index) {
                  final user = controllerSearchUsers.userList[index];
                  return ListTile(
                    onTap: (){
                      Get.to(ScreenUserProfileInfo(id: user.id));
                    },
                    title: Text('${user.fName} ${user.lName}'),
                    subtitle: Text(user.email),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage("${AppEndPoint.userProfile}${user.profile}"),
                    )
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
