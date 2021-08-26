import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_auth.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/images.dart';
import 'package:smart_chef/view/screen/support_screen.dart';
import 'package:smart_chef/view/screen/themes.dart';
import 'package:smart_chef/view/screen/widget/statistics.dart';
import 'package:smart_chef/view/widget/notifications_icon.dart';
import 'package:wakelock/wakelock.dart';
import 'dashboard_screen.dart';

import 'widget/orders_history.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _subHome = [
    DashboardScreen(),
    OrdersHistory(),
    Statistics(),
    Themes(),
  ];
  AuthGet authGet = Get.find();

  HomeGet homeGet = Get.find();
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    homeGet.onDispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey2E3134,
        body: Obx(() {
          return SafeArea(
            child: homeGet.firstOrderHistoryLoad.value &&
                    homeGet.firstDDashboardLoad.value
                ? Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        loadingWidget(),
                      ],
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(background),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      navigationBar(selectedIndex: homeGet.currentScreen.value),
                      SizedBox(width: 10),
                      Expanded(
                        child: _subHome[homeGet.currentScreen.value],
                      ),
                    ],
                  ),
          );
        }));
  }

  Widget navigationBar({@required int selectedIndex}) {
    return Container(
      width: 70,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 14),
          IconButton(
            onPressed: () {
              homeGet.setCurrentScreen(index: 0);
            },
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.dashboard,
              size: 50,
              color: selectedIndex == 0 ? Colors.white : grey5B6163,
            ),
          ),
          SizedBox(height: 60),
          IconButton(
            onPressed: () {
              homeGet.setCurrentScreen(index: 1);
            },
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.assignment,
              size: 50,
              color: selectedIndex == 1 ? Colors.white : grey5B6163,
            ),
          ),
          SizedBox(height: 60),
          IconButton(
            onPressed: () {
              homeGet.setCurrentScreen(index: 2);
            },
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.pie_chart,
              size: 50,
              color: selectedIndex == 2 ? Colors.white : grey5B6163,
            ),
          ),
          SizedBox(height: 60),
          IconButton(
            onPressed: () {
              homeGet.setCurrentScreen(index: 3);
            },
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.theater_comedy,
              size: 50,
              color: selectedIndex == 3 ? Colors.white : grey5B6163,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () => Get.to(() => SupportScreen()),
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.contact_support_outlined,
              size: 50,
              color: grey5B6163,
            ),
          ),
          SizedBox(height: 60),
          IconButton(
            onPressed: () {
              authGet.isLoginLoading.value = false;
              authGet.loginSuccess.value = false;
              authGet.signOut();
            },
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.logout,
              size: 50,
              color: grey5B6163,
            ),
          ),
          SizedBox(height: 10),
      
      
        ],
      ),
      decoration: BoxDecoration(
        color: grey383D42,
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(13),
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            logo,
            height: 350,
            width: 350,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 60),
          CircularProgressIndicator(
            strokeWidth: 5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
