import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/controller/share_preferance.dart';
import 'package:smart_chef/model/order.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/view/widget/date_widget.dart';
import 'package:smart_chef/view/widget/loading_indicator.dart';
import 'package:smart_chef/view/widget/notifications_icon.dart';
import '../canves.dart';

class Dashboard1 extends StatelessWidget {
  HomeGet homeGet = Get.find();

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
              SizedBox(height: 30),
              FlatButton(
                color: Colors.white,
                onPressed: () => homeGet.getDashboard(),
                child: Text('RETRY'),
              ),
            ],
          )
        : Row(
            children: [
              Container(
                width: 100,
                color: grey5B6163,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NotificationsIcon(
                      shown: homeGet.showNotifications.value,
                      notificationsCount:
                          homeGet.dashboardModel.value.newOrders.length ?? 0,
                      onTap: () {
                        homeGet.toggleNotificationsView();
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount:
                            homeGet.dashboardModel.value.newOrders.length ?? 0,
                        itemBuilder: (_, index) => orderRemainingTimeBuilder(
                          deliveryTimeint: 1,
                          orderTime: homeGet
                              .dashboardModel.value.newOrders[index].orderTime,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        right: 20,
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
                      homeGet.showNotifications.value
                          ? homeGet.dashboardModel.value.newOrders.isEmpty ??
                                  true
                              ? emptyOrders(
                                  time: homeGet.timeString,
                                  isDashboardLoading:
                                      homeGet.isDashboardLoading.value,
                                )
                              : ordersNewOrdersDisplay(
                                  newOrders:
                                      homeGet.dashboardModel.value.newOrders,
                                )
                          : homeGet.dashboardModel.value.workingOrders ==
                                      null ??
                                  ""
                              ? emptyOrders(
                                  time: homeGet.timeString,
                                  isDashboardLoading:
                                      homeGet.isDashboardLoading.value,
                                )
                              : ordersWorkingOrders(
                                  ordersWork: homeGet
                                      .dashboardModel.value.workingOrders,
                                ),
                    ],
                  )),
            ],
          ));
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
                      onPressed: () => homeGet.getDashboard(),
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
            ],
          ),
          Text(
            ShereHelper.sHelper.getDomin(),
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

  Widget ordersNewOrdersDisplay({List<Order> newOrders}) {
    return ListView.separated(
      key: Key('ordersNotificationsDisplay'),
      shrinkWrap: true,
      primary: true,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: newOrders.length,
      separatorBuilder: (_, index) => SizedBox(width: 16),
      itemBuilder: (_, index) => Capturer(
        key: Key(newOrders[index].orderCode),
        order: newOrders[index],
      ),
    );
  }

  Widget ordersWorkingOrders({List<Order> ordersWork}) {
    print(ordersWork);
    return ListView.separated(
      key: Key('ordersDisplay'),
      shrinkWrap: true,
      primary: true,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: ordersWork.length,
      separatorBuilder: (_, index) => SizedBox(width: 16),
      itemBuilder: (_, index) => Capturer(
        key: Key(ordersWork[index].orderCode),
        isNotification: false,
        order: ordersWork[index],
      ),
    );
  }

  Widget orderRemainingTimeBuilder({String orderTime, int deliveryTimeint}) {
    final DateTime deliverTime =
        DateTime.parse(orderTime).add(Duration(minutes: deliveryTimeint));
    Duration remainingTime = deliverTime.difference(DateTime.now());

    List<String> dateComponents = remainingTime.toString().split(':');
    String hour = dateComponents[0];
    String minute = dateComponents[1];
    return InkWell(
      onTap: () {
        homeGet.setNotificationView(show: true);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        color: hour.contains('-') ? redF55B31 : grey383D42,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getHourString(hour: hour),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: greyDEDEDE,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  minute,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: greyDEDEDE,
                  ),
                ),
                Text(
                  'min',
                  style: TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: greyDEDEDE,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getHourString({@required String hour}) {
    int hourInt = int.parse(hour).abs();
    if (hourInt == 0) {
      return '';
    } else {
      return '$hourInt';
    }
  }
}
