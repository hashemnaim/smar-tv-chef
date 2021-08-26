import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/controller/server.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/consts.dart';
import 'package:smart_chef/view/widget/loading_indicator.dart';

class Statistics extends StatelessWidget {
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
        : Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: grey383D42,
                  height: 170,
                  padding: const EdgeInsets.symmetric(
                    vertical: 65,
                    horizontal: 36,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getDate(timeString: homeGet.timeString),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 33,
                          color: Colors.white,
                        ),
                      ),
                      homeGet.isDashboardLoading.value
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
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    statisticItem(
                      title: 'Totalt bestillinger',
                      count: homeGet.dashboardModel.value.countOrders,
                      color: greyDEDEDE,
                    ),
                    SizedBox(width: 60),
                    statisticItem(
                      title: 'Sene bestillinger',
                      count: 0,
                      //homeGet.dashboardModel.value.lateOrders,
                      color: Colors.red,
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ));
  }

  Widget statisticItem({String title, int count, Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 80),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 100,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: grey383D42,
        borderRadius: BorderRadius.all(Radius.circular(150)),
      ),
    );
  }

  String getDate({DateTime timeString}) {
    return '${getDayName(date: timeString)} - ${getDayNumMonthCombo(date: timeString)} ${timeString.year}';
  }

  String getDayName({DateTime date}) {
    return '${days[date.weekday - 1]}';
  }

  String getDayNumMonthCombo({DateTime date}) {
    return '${date.day} ${months[date.month - 1]}';
  }
}
