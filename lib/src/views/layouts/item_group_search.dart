import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../api_integration/create_Group_APIService/create_group_model_repository/model_and_fetchGroups.dart';
import '../../../constants/ApiEndPoint.dart';

class ItemGroupSearch extends StatelessWidget {
  Groups searchGroup;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.sp,
            backgroundColor: Color(0xff02FF9E),
            backgroundImage:
                NetworkImage("${AppEndPoint.groupProfile}${searchGroup.img}"),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  searchGroup.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                ),
                Text(
                  searchGroup.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFFAAB2B7),
                  ),
                ),
              ],
            ).marginSymmetric(horizontal: 10.w),
          ),
        ],
      )
          .marginSymmetric(
            vertical: 10.sp,
          )
          .marginSymmetric(
            horizontal: 6.sp,
          ),
    );
  }

  ItemGroupSearch({
    required this.searchGroup,
  });
}
