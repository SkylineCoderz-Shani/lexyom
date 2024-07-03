import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../constants/colors.dart';
import '../CustomWidget/custom_ContainerFreeContent.dart';
import '../CustomWidget/custom_Container_ServicesDetails.dart';
import '../HomeScreen/HomeView/layout_user_home.dart';
import '../HomeScreen/home_screen.dart';

class ScreenFreeContent extends StatelessWidget {
  const ScreenFreeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 25.sp,
          left: 20.sp,
          right: 20.sp,
        ),
        child: ListView(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                  },
                  child: Icon(Icons.arrow_back, color: Colors.black,).marginOnly(
                    bottom: 35.sp,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Free Content", style: title1,),
                    Text("Explore our key partners and tools to elevate\nyour trading journey.", style: subtitle2,),
                  ],
                ).marginSymmetric(
                  horizontal: 10.sp,
                )
              ],
            ),
            SizedBox(
              height: 15.sp,
            ),
            CustomContainerFreeContent(
              title: 'Facebook',
              subtitle: 'Keep up with our news and new releases by\nfollowing our instagram account.', leading: CircleAvatar(
                radius: 23.sp,
                backgroundColor: Colors.transparent,
                child: Image.asset("assets/icons/facebook_icon.png"),
              ),
            ),
            CustomContainerFreeContent(
              title: 'Instagram',
              subtitle: 'Follow us for the latest news and updates on\nour products and services.', leading: CircleAvatar(
              radius: 23.sp,
              backgroundColor: Colors.transparent,
              child: Image.asset("assets/icons/instagram_icon.png"),
            ),
            ).marginSymmetric(
              vertical: 10.sp,
            ),
            CustomContainerFreeContent(
              title: 'Twitter',
              subtitle: 'Stay informed about out latest releases and\nannouncements by following us here.', leading: CircleAvatar(
              radius: 23.sp,
              backgroundColor: Colors.transparent,
              child: Image.asset("assets/icons/twitter_icon.png"),
            ),
            ),
            CustomContainerFreeContent(
              title: 'Linkedin',
              subtitle: 'Follow us on LinkedIn for updates on our\ncompany news and developments.', leading: CircleAvatar(
              radius: 23.sp,
              backgroundColor: Colors.transparent,
              child: Image.asset("assets/icons/linkdin_icon.png"),
            ),
            ).marginSymmetric(
              vertical: 10.sp,
            ),
            CustomContainerFreeContent(
              title: 'YouTube',
              subtitle: 'Subscribe to our channel for videos\nshowcasing our latest products and offerings.', leading: CircleAvatar(
              radius: 23.sp,
              backgroundColor: Colors.transparent,
              child: Image.asset("assets/icons/youtube_icon.png"),
            ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            CustomContainerFreeContent(
              title: 'Reddit',
              subtitle: 'Stay in the loop with our news and updates\nby following our subreddit.', leading: CircleAvatar(
              radius: 23.sp,
              backgroundColor: Colors.transparent,
              child: Image.asset("assets/icons/reddit_icon.png"),
            ),
            ),

          ],
        ),
      ),
    );
  }
}
