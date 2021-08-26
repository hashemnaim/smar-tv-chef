import 'order.dart';

class DashboardModel {
  int countOrders;
  List<Order> newOrders=List<Order>();
  List<Order> workingOrders=List<Order>();
  List<Order> ordersHistory=List<Order>();

  DashboardModel({
    this.countOrders = 0,
    this.newOrders = const [],
    this.workingOrders = const [],
    this.ordersHistory = const [],
  });

  DashboardModel.fromJson(Map<String, dynamic> json) {
    countOrders = json['order_count'];
    if (json['data'].length != 0) {
      json['data'].forEach((v) {
        print(v);
        if (v['status']['id'] == 0) {
          print(v['status']['id']);

          newOrders.add(new Order.fromJson(v));
          if (newOrders == null) {
            newOrders = [];
          }
        } else if (v['status']['id'] == 1) {
          print(v['status']['id']);
          workingOrders.add(new Order.fromJson(v));
           if (workingOrders == null) {
            workingOrders = [];}
        } else if (v['status']['id'] > 2) {
          ordersHistory.add(new Order.fromJson(v));
           if (ordersHistory == null) {
            ordersHistory = [];
          }
        }
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['order_count'] = this.countOrders;
  //   data['status'] = this.status;
  //   if (status == 0) {
  //     data['data'] = this.newOrders.map((v) => v.toJson()).toList();
  //   } else {
  //     data['data'] = this.workingOrders.map((v) => v.toJson()).toList();
  //   }

  //   return data;
  // }
}
