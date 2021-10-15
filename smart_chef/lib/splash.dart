import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_auth.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/controller/share_preferance.dart';
import 'package:smart_chef/utils/images.dart';
import 'package:smart_chef/view/screen/home_screen.dart';
import 'package:smart_chef/view/screen/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'controller/notification_firebase.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  HomeGet homeGet = Get.find();
  AuthGet auth = Get.find();

  @override
  void initState() {
    var delay = Duration(seconds: 1);
    Future.delayed(delay, () async {
      String theme = await ShereHelper.sHelper.getValue('theme');
      homeGet.dashpordThemes.value = int.parse(theme == null ? "1" : theme);
      if (ShereHelper.sHelper.getToken() != null ||
          ShereHelper.sHelper.getDomin() != null) {
        auth.domenController.value.text = ShereHelper.sHelper.getDomin();
        print(ShereHelper.sHelper.getDomin());
        homeGet.token.value = ShereHelper.sHelper.getToken();
        homeGet.getDashboard();
        NotificationHelper().initialNotification();

        Get.offAll(() => HomeScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(background),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SafeArea(child: loadingWidget()),
          ),
        ],
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
          SizedBox(height: 80),
          CircularProgressIndicator(
            strokeWidth: 5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
