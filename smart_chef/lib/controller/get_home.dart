import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:smart_chef/controller/server.dart';
import 'package:smart_chef/model/dashboard_model.dart';
import 'package:smart_chef/model/order.dart';
import 'package:smart_chef/model/ringer_model.dart';
import 'get_auth.dart';
import 'share_preferance.dart';

class HomeGet extends GetxController {
  Timer _timer;
  bool isInitialized = false;
  RxBool isDashboardLoading = false.obs;
  Rx<DashboardModel> dashboardModel = DashboardModel().obs;
  var notAcceptdeliveryOrderMap = [].obs;
  RxString errorLoadingDashboard = "".obs;
  RxString token = "".obs;
  AuthGet authGet = Get.find();
  var notificationMap = {}.obs;
  int numberOrdersDelivery = 0;
  int numberNotificationDelivery = 0;
  int numberNotificationOsra = 0;
  RxInt dashpordThemes = 0.obs;
  RxBool firstDDashboardLoad = true.obs;
  RxBool isconnected = false.obs;
  RxBool firstOrderHistoryLoad = false.obs;
  RxBool showNotifications = false.obs;
  DateTime timeString;
  RxList ordersHistory = [].obs;
  var orderDeliveryDetailsMap;
  String type;
  RxBool isOrdersHistoryLoading = false.obs;

  String errorLoadingOrdersHistory;
  @override
  void onInit() {
    super.onInit();

    if (!isInitialized) {
      // audioPlayer.state = AudioPlayerState.STOPPED;
      // audioCache.load('sounds/alert.mp3');
      // isInitialized = true;
    }
    periodicAction();
    Future.delayed(
      Duration(seconds: 60 - timeString.second),
      () {
        periodicAction();
        _timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
          periodicAction();
        });
      },
    );
  }

  void onDispose() {
    _timer?.cancel();
    _timer = null;
  }

  RxBool muted = false.obs;

  changeNumberNotificationOsra() async {
    Server.serverProvider.dashboardContent();
    int number1 = notificationMap['purchase'].length;
    int number2 = ShereHelper.sHelper.getNumberNotificationOsra() ?? 0;
    if (number1 > number2) {
      numberNotificationOsra = number1 - number2;
      ShereHelper.sHelper.setNumberNotificationOsra(number1);
    } else if (number1 == number2) {
      numberNotificationOsra = 0;
    }

    update(['notification']);
  }

  changeNumberOrdersDelivery() async {
    Server.serverProvider.dashboardContent();
    int number1 = notAcceptdeliveryOrderMap.length;
    // int number2 = ShereHelper.sHelper.getNumberOrdersDelivery() ?? 0;

    numberOrdersDelivery = number1;

    update(['notification']);
  }

  var currentScreen = 0.obs;

  void setCurrentScreen({int index}) {
    this.currentScreen.value = index;
  }

  var rangBefore = {}.obs;
  String errorUpdatingOrder;

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  // void playAlert() async {
  //   if (audioPlayer.state != AudioPlayerState.PLAYING) {
  //     audioPlayer.state = AudioPlayerState.PLAYING;
  //     audioPlayer = await audioCache.loop('sounds/alert.mp3');
  //   }
  // }

  void toggleAlert({String orderCode, bool stop = true}) {
    if (stop) {
      audioPlayer.stop();
    }
    if (rangBefore.containsKey(orderCode)) {
      rangBefore[orderCode].enable = !rangBefore[orderCode].enable;
    }
  }

  void pauseAlertForOrder({String orderCode}) {
    audioPlayer.stop();
    if (rangBefore.containsKey(orderCode)) {
      rangBefore[orderCode].dateTime = DateTime.now().toString();
    } else {
      rangBefore[orderCode] = RingerModel(
        enable: true,
        dateTime: DateTime.now().toString(),
      );
    }
  }

  void disableAlert({String orderCode}) {
    if (rangBefore.containsKey(orderCode)) {
      rangBefore.remove(orderCode);
      audioPlayer.stop();
    }
  }

  void toggleNotificationsView() {
    showNotifications.value = !showNotifications.value;
  }

  void setNotificationView({bool show}) {
    showNotifications.value = show;
  }

  void _getTime() {
    timeString = DateTime.now();
  }

  void periodicAction() {
    _getTime();
    if ((dashboardModel.value.newOrders.isEmpty ?? true) &&
        (dashboardModel.value.workingOrders.isEmpty ?? true)) {
      audioPlayer.stop();
    } else {
      for (Order order in dashboardModel.value.newOrders) {
        lateOrderHandler(order: order);
      }
      for (Order order in dashboardModel.value.workingOrders) {
        lateOrderHandler(order: order);
      }
    }
  }

  void lateOrderHandler({Order order}) {
    final Duration deliverTime = Duration(minutes: 1);
    final DateTime orderTime = DateTime.parse(order.orderTime).add(deliverTime);
    Duration remainingTime = orderTime.difference(DateTime.now());

    bool enable = true;

    if (rangBefore.containsKey(order.orderCode)) {
      Duration _duration = DateTime.now()
          .difference(DateTime.parse(rangBefore[order.orderCode].dateTime));
      int res = _duration.compareTo(Duration(minutes: 1));
      bool isFiveMinutes = res == 1 || res == 0;
      if (isFiveMinutes) {
        enable = rangBefore[order.orderCode].enable;
      } else {
        enable = false;
      }
    }

    if (remainingTime.isNegative && enable) {
      // playAlert();
      rangBefore[order.orderCode] = RingerModel(
        enable: true,
        dateTime: DateTime.now().toString(),
      );
    }
  }

  setindexList(var listtt) {
    this.orderDeliveryDetailsMap = listtt;
    update(['listtt']);
  }

  void getDashboard() async {
    errorLoadingDashboard = null;
    isDashboardLoading.value = true;

    // runZoned(() async {
    await Server.serverProvider.dashboardContent().then((value) {
      isDashboardLoading.value = false;
      firstDDashboardLoad.value = false;

      dashboardModel.value = value;

      print(dashboardModel.value);
      if (dashboardModel.value.newOrders.isEmpty) {
        showNotifications.value = false;
      }
    });
    // }, onError: (e, s) {
    // if (e is DioError) {
    //   String error = e.error;
    //   print('DioError in getDashboard: $error');
    //   errorLoadingDashboard.value = error;
    // } else {
    //   errorLoadingDashboard.value = e.toString();
    // }

    //   print(e.toString());
    //   print(s.toString());
    //   isDashboardLoading.value = false;
    // });
  }

  // void getOrdersHistory() {
  //   errorLoadingOrdersHistory = null;
  //   isOrdersHistoryLoading = true.obs;

  //   runZoned(() {
  //     DateTime now = DateTime.now();
  //     String nowString = '${now.year}-${now.month}-${now.day}';
  //     Server.serverProvider.ordersHistory(data: {
  //       'start_date': nowString,
  //       'end_date': nowString,
  //     }).then((value) {
  //       isOrdersHistoryLoading = false.obs;
  //       firstOrderHistoryLoad.value = false;
  //       ordersHistory.assignAll(value);
  //     });
  //   }, onError: (e, s) {
  //     if (e is DioError) {
  //       String error = e.error;
  //       print('DioError in getOrdersHistory: $error');
  //       errorLoadingOrdersHistory = error;
  //       if (error == 'Auth Token Not Found') {
  //         authGet.signOut();
  //       }
  //     } else {
  //       print('error in getOrdersHistory, ${e.runtimeType}');
  //       errorLoadingOrdersHistory = e.toString();
  //     }

  //     isOrdersHistoryLoading = false.obs;
  //   });
  // }

  Future<void> updateOrderStatus({Map<String, dynamic> data}) async {
    await runZoned(() async {
      errorUpdatingOrder = null;

      await Server.serverProvider.updateOrder(data: data);
      if (dashboardModel.value.newOrders.isEmpty) {
        print(showNotifications.value);
        showNotifications.value = false;
      }
      if (data['status'] > 2) {
        rangBefore.remove(data['order_code']);
      }
    }, onError: (e, s) {
      if (e is DioError) {
        String error = e.error;
        print('DioError in updateOrderStatus: $error');
        errorUpdatingOrder = error;
        if (error == 'Auth Token Not Found') {
          authGet.signOut();
        }
      } else {
        print('error in updateOrderStatus, ${e.runtimeType}');
        print('e: ${e.toString()}');
        errorUpdatingOrder = e.toString();
      }
    });
  }
}
