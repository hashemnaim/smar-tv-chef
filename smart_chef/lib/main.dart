import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:smart_chef/controller/get_auth.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/splash.dart';
import 'package:get/get.dart';
import 'controller/share_preferance.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light));
  await ShereHelper.sHelper.initSharedPrefrences();

  Get.lazyPut(() => HomeGet(), fenix: true);
  Get.lazyPut(() => AuthGet(), fenix: true);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      allowFontScaling: true,
      builder: () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Chef',
          theme: ThemeData(
            fontFamily: 'Montserrat',
            primarySwatch: Colors.grey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Splash()),
    );
  }
}
