import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class ScreenNotificationWithoutIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Get.back(result: true);
          }, icon: Icon(Icons.arrow_back, color: Colors.black,)),
          centerTitle: true,
          title: Text('Notifications', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/notification.png"),
              ListTile(
                title: Text('Anthony just messaged you and is\naccessing a folder named\n“forex”', style: subtitle3),
                leading:  Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.bell_fill, color: Colors.black, size: 27,),
                  ),
                ),
                subtitle: Text("10 minutes ago", style: subtitle2,),
              ),
              ListTile(
                title: Text('You open the access for “forex” folder to shareable link.', style: subtitle3),
                leading:  Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.bell_fill, color: Colors.black, size: 27,),
                  ),
                ),
                subtitle: Text("2 hours ago", style: subtitle2,),
              ),
              ListTile(
                title: Text('Let’s set-up your account, make your account more recognizable', style: subtitle3),
                leading:  Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.bell_fill, color: Colors.black, size: 27,),
                  ),
                ),
                subtitle: Text("3 Days", style: subtitle2,),
              ),
              ListTile(
                title: Text('Upload your first picture and start learning throughout the app', style: subtitle3),
                leading:  Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.bell_fill, color: Colors.black, size: 27,),
                  ),
                ),
                subtitle: Text("Yesterday", style: subtitle2,),
              ),
              ListTile(
                title: Text('Welcome to Skorpio! Enjoy all the easy access for file management', style: subtitle3),
                leading:  Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.bell_fill, color: Colors.black, size: 27,),
                  ),
                ),
                subtitle: Text("1 week ago", style: subtitle2,),
              ),
              ListTile(
                title: Text('Anthony just messaged you and is\naccessing a folder named\n“forex”', style: subtitle3),
                leading:  Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.bell_fill, color: Colors.black, size: 27,),
                  ),
                ),
                subtitle: Text("10 minutes ago", style: subtitle2,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
