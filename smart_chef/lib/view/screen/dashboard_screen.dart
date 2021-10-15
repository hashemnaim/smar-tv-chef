import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/utils/colors.dart';

import 'package:smart_chef/view/screen/widget/dashboard3.dart';

import 'widget/dashboard1.dart';
import 'widget/dashboard2.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key key,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Widget> _subDashboard = [
    Dashboard1(),
    Dashboard2(),
    Dashboard3(),
  ];

  HomeGet homeGet = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey2E3134,
        body: Obx(() {
          return Container(
            child: _subDashboard[homeGet.dashpordThemes.value],
          );
        }));
  }
}
