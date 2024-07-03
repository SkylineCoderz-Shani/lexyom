import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../CustomWidget/custom_Container_ServicesDetails.dart';
import '../HomeScreen/home_screen.dart';

class ScreenPartnerAndTools extends StatelessWidget {
  const ScreenPartnerAndTools({super.key});

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
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ).marginOnly(
                    bottom: 35.sp,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Partners and Tools",
                        style: title1,
                      ),
                      Text(
                        "Explore our key partners and tools to elevate your trading journey.",
                        style: subtitle2,
                      ),
                    ],
                  ).marginSymmetric(
                    horizontal: 10.sp,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15.sp,
            ),
            CustomMarketDataContainer(
              title: 'Bloomberg',
              subtitle:
                  'Get live updates on stock prices, market\ntrends, and trading volumes to make informed\ndecisions instantly.',
              leading: CircleAvatar(
                radius: 23.sp,
                backgroundColor: Colors.transparent,
                child: Image.asset("assets/icons/bloombreg_icon.png"),
              ),
            ),
            CustomMarketDataContainer(
              title: 'Paypal',
              subtitle:
                  'Get live updates on stock prices, market trends, and trading volumes to make informed decisions instantly.',
              leading: CircleAvatar(
                radius: 23.sp,
                backgroundColor: Colors.transparent,
                child: Image.asset("assets/icons/paypal_icon.png"),
              ),
            ).marginSymmetric(
              vertical: 10.sp,
            ),
            CustomMarketDataContainer(
              title: 'Symantec',
              subtitle:
                  'Get live updates on stock prices, market trends, and trading volumes to make informed decisions instantly.',
              leading: CircleAvatar(
                radius: 23.sp,
                backgroundColor: Colors.transparent,
                child: Image.asset("assets/icons/trading_tool.png"),
              ),
            ),
            CustomMarketDataContainer(
              title: 'Morningstar',
              subtitle:
                  'Get live updates on stock prices, market trends, and trading volumes to make informed decisions instantly.',
              leading: CircleAvatar(
                radius: 23.sp,
                backgroundColor: Colors.transparent,
                child: Image.asset("assets/icons/trading_tool.png"),
              ),
            ).marginSymmetric(
              vertical: 10.sp,
            ),
            CustomMarketDataContainer(
              title: 'Investopedia',
              subtitle:
                  'Get live updates on stock prices, market trends, and trading volumes to make informed decisions instantly.',
              leading: CircleAvatar(
                radius: 23.sp,
                backgroundColor: Colors.transparent,
                child: Image.asset("assets/icons/portfolio_icon.png"),
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            CustomMarketDataContainer(
              title: 'Charles Schwab',
              subtitle:
                  'Get live updates on stock prices, market trends, and trading volumes to make informed decisions instantly.',
              leading: CircleAvatar(
                radius: 23.sp,
                backgroundColor: Colors.transparent,
                child: Image.asset("assets/icons/account_management.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
