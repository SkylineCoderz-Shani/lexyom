import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../controllers/controller_process.dart';
import 'layouts/item_process_point.dart';

class ScreenCompletedProject extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    ProcessController processController = Get.put(ProcessController());

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            processController.fetchProcessInfo();
            // Implement your refresh logic here
          },
          child: Obx(() {
            return (processController.isLoading.value)
                ? Center(child: CircularProgressIndicator())
                : processController.process.value == null
                    ? Center(child: Text("No Process Found"))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.arrow_back),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      processController
                                          .process.value!.data.process.title,
                                      style: categoryFontText,
                                    ).marginOnly(top: 10.h),
                                    Text(
                                      processController.process.value!.data
                                          .process.description,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: processController
                                    .process.value!.data.process.points.isNotEmpty
                                ? ListView.builder(
                                    itemCount: processController.process.value!
                                        .data.process.points.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var points = processController.process
                                          .value!.data.process.points[index];
                                      return ItemProcessPoint(
                                        point: points,
                                      ).marginSymmetric(vertical: 6.h);
                                    },
                                  )
                                : Center(child: Text("No Point added Yet")),
                          )
                        ],
                      ).marginSymmetric(horizontal: 20.w,);
          }),
        ),
      ),
    );
  }
}
