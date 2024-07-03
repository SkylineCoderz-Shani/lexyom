import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lexyom/extensions/time_ago.dart';
import 'package:lexyom/src/views/screen_userProfileInfo.dart';
import '../../api_integration/create_Group_APIService/create_group_model_repository/model_and_fetchGroups.dart';
import '../../api_integration/create_Group_APIService/joinGroup_APIServices/model/JoinGroupModel.dart';
import '../../constants/ApiEndPoint.dart';
import '../../constants/colors.dart';
import '../../controllers/controller_user.dart';
import '../../models/group_info.dart';

class ScreenViewGroupAdmin extends StatelessWidget {
 List<Admin> adminList;
  @override
  Widget build(BuildContext context) {
    UserController controllerUser = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Group Admins"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20)
        ),
        child: ListView.builder(
          itemCount: adminList
              .length,
          itemBuilder: (context, index) {
            var remainingUser = adminList[index];
            return FutureBuilder<Map<String,dynamic>?>(
              future: controllerUser.getUserInfo(remainingUser.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final user = snapshot.data;
                  log(user!.toString());
                  if (user != null) {
                    log(user.toString());
                    // DateTime dateTime = ;
                    return Column(children: [
                      ListTile(
                        onTap: (){
                          Get.to(ScreenUserProfileInfo(id: user['id']));
                        },
                        title: Text(user['name'], style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),),
                        subtitle: Text(
                          "last seen ${DateTime.parse(user['last_seen']?? "2024-05-29 09:17:25").toRelativeTime}", style: subtitle1,),
                        leading:CircleAvatar(
                          backgroundImage: NetworkImage(
                              "${AppEndPoint.userProfile}${user["profile"]}"
                          ),
                        ),
                        // trailing:(isAdmin)?PopupMenuButton(
                        //   icon: Icon(Icons.more_vert, color: Colors.white,),
                        //   itemBuilder: (BuildContext context) {
                        //
                        //     return [
                        //       PopupMenuItem(child: Text("Make Admin"),value: "Make Admin",),
                        //       PopupMenuItem(child: Text("Remove"),value: "Remove",),
                        //     ];
                        //   },
                        //   onSelected: (value){
                        //     if(value=="Make Admin"){
                        //       log(value.toString());
                        //       groupController.addGroupAdmin(group.id, member.id);
                        //     }
                        //     else if(value=="Remove"){
                        //       log(value.toString());
                        //       groupController.removeUser(group.id,member.id);
                        //     }
                        //   },
                        // ):SizedBox(),
                      ),
                      Divider(
                        indent: 69.sp,
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                    ],);
                  } else {
                    return Center(child: Text('User data not found'));
                  }
                } else {
                  return Center(child: Text('No data'));
                }
              },
            );
          },
        ),
      ),
    );
  }

 ScreenViewGroupAdmin({
    required this.adminList,
  });
}
