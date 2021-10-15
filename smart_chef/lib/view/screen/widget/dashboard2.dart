import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/controller/server.dart';
import 'package:smart_chef/controller/share_preferance.dart';
import 'package:smart_chef/model/order.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/view/widget/date_widget.dart';
import 'package:smart_chef/view/widget/loading_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../canves.dart';

class Dashboard2 extends StatefulWidget {
  @override
  _Dashboard2State createState() => _Dashboard2State();
}

class _Dashboard2State extends State<Dashboard2> {
  HomeGet homeGet = Get.find();

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => homeGet.getDashboard());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeGet.dashboardModel.value == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error occurred while loading Dashboard',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'message: ${homeGet.errorLoadingDashboard}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              FlatButton(
                color: Colors.white,
                onPressed: () => Server.serverProvider.dashboardContent(),
                child: Text('RETRY'),
              ),
            ],
          )
        : Obx(() => Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: Text(
                    '${homeGet.dashboardModel.value.countOrders ?? ""}',
                    textAlign: TextAlign.end,
                    strutStyle: StrutStyle(
                      height: 0.8,
                      fontSize: 206,
                      forceStrutHeight: true,
                    ),
                    style: TextStyle(
                      color: grey383B3E,
                      fontSize: 206,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                homeGet.dashboardModel.value.workingOrders.isEmpty ?? true
                    ? emptyOrders(
                        time: homeGet.timeString,
                        isDashboardLoading: homeGet.isDashboardLoading.value,
                      )
                    : ordersDisplay(
                        orders: homeGet.dashboardModel.value.workingOrders,
                      ),
                homeGet.dashboardModel.value.newOrders.isNotEmpty
                    ? Container(
                        // height: double.infinity,
                        // width: 1200,
                        // color: Colors.black54.withOpacity(0.5),
                        child: Center(
                          child: ordersNotificationsDisplay(
                            notifications:
                                homeGet.dashboardModel.value.newOrders,
                          ),
                        ),
                      )
                    : Container(),
              ],
            )));
  }

  Widget emptyOrders({
    DateTime time,
    bool isDashboardLoading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
        right: 50,
        left: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Velkommen Chef!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              isDashboardLoading
                  ? LoadingIndicator(
                      height: 25,
                      width: 25,
                      margin: EdgeInsets.only(right: 10),
                    )
                  : IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Server.serverProvider.dashboardContent(),
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
            ],
          ),
          Text(
            "   " + ShereHelper.sHelper.getDomin(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: grey484B4E,
              fontSize: 50.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          DateWidget(date: time),
          Spacer(),
          Text(
            '${time.hour < 10 ? '0${time.hour}' : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}',
            textAlign: TextAlign.center,
            strutStyle: StrutStyle(
              height: 0.8,
              fontSize: 206,
              forceStrutHeight: true,
            ),
            style: TextStyle(
              color: grey484B4E,
              fontSize: 206,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(
            '',
            textAlign: TextAlign.end,
            strutStyle: StrutStyle(
              height: 0.8,
              fontSize: 206,
              forceStrutHeight: true,
            ),
            style: TextStyle(
              color: grey383B3E,
              fontSize: 206,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget ordersNotificationsDisplay({
    List<Order> notifications,
  }) {
    print(notifications);
    return Stack(
        key: Key('ordersNotificationsDisplay'),
        children: notifications
            .map(
              (e) => Capturer(
                key: Key(e.orderCode),
                order: e,
              ),
            )
            .toList());
  }

  Widget ordersDisplay({List<Order> orders}) {
    return ListView.separated(
      key: Key('ordersDisplay'),
      shrinkWrap: true,
      primary: true,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
      itemCount: orders.length,
      separatorBuilder: (_, index) => SizedBox(width: 8),
      itemBuilder: (_, index) => Capturer(
        key: Key(orders[index].orderCode),
        isNotification: false,
        order: orders[index],
      ),
    );
  }

  // Widget orderRemainingTimeBuilder({String orderTime, int deliveryTime}) {
  //   final DateTime deliverTime =
  //       DateTime.parse(orderTime).add(Duration(minutes: deliveryTime - 1));
  //   Duration remainingTime = deliverTime.difference(DateTime.now());

  //   List<String> dateComponents = remainingTime.toString().split(':');
  //   String hour = dateComponents[0];
  //   String minute = dateComponents[1];
  //   return InkWell(
  //     onTap: () {
  //       homeGet.setNotificationView(show: true);
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.only(bottom: 10),
  //       padding: const EdgeInsets.all(10),
  //       color: hour.contains('-') ? redF55B31 : grey383D42,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //             getHourString(hour: hour),
  //             style: TextStyle(
  //               fontSize: 36,
  //               fontWeight: FontWeight.bold,
  //               color: greyDEDEDE,
  //             ),
  //           ),
  //           Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 minute,
  //                 style: TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.bold,
  //                   color: greyDEDEDE,
  //                 ),
  //               ),
  //               Text(
  //                 'min',
  //                 style: TextStyle(
  //                   // fontSize: 30,
  //                   fontWeight: FontWeight.bold,
  //                   color: greyDEDEDE,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  String getHourString({@required String hour}) {
    int hourInt = int.parse(hour).abs();
    if (hourInt == 0) {
      return '';
    } else {
      return '$hourInt';
    }
  }
}
