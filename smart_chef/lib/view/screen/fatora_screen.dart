import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_chef/model/order.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FatoraScreen extends StatelessWidget {
  final Order order;
  FatoraScreen({Key key, this.order});
  String unitTime;
  String timeOrderRang;
  @override
  Widget build(BuildContext context) {
    DateTime timeOrder = DateTime.parse(order.orderTime);

    Duration dur = timeOrder.difference(DateTime.now());
    if (dur.toString().substring(0, 1) == "0") {
      unitTime = "muints";
      timeOrderRang = dur.toString().substring(2, 4);
      print(timeOrderRang);
    } else {
      unitTime = "hours";
      timeOrderRang = dur.toString().substring(0, 4);
      print(timeOrderRang);
    }

    return Container(
      width: 90.w,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Center(
                  child: Container(
                      width: 120.w,
                      height: 40.h,
                      child: Image.asset(
                        "assets/images/fatora.png",
                        color: Colors.black,
                      ))),
              SizedBox(height: 6.h),
              Row(children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(width: 4.w),
                Text(
                  order.customerName + " # " + order.id.toString(),
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ]),
              SizedBox(height: 4.h),
              Row(children: [
                Icon(
                  Icons.phone,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(width: 4.w),
                Text(
                  order.customerMobile,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ]),
              SizedBox(height: 4.h),
              Row(children: [
                Icon(
                  Icons.car_repair,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(width: 4.w),
                Text(order.delivery,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(width: 10.w),
                order.numberOfPerson == null
                    ? Container()
                    : Text(
                        order.numberOfPerson.toString() ?? "1" + " Person",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
              ]),
              SizedBox(height: 4.w),
              Row(children: [
                Icon(
                  Icons.history_toggle_off,
                  size: 20,
                ),
                SizedBox(width: 4.w),
                Text(
                  timeOrderRang +
                      "  " +
                      unitTime +
                      "  " +
                      "(${DateFormat('kk:mm').format(timeOrder)})",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ]),
              SizedBox(height: 4.w),
              order.delivery == "Takeaway"
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        order.numberOfPerson == null
                            ? Container()
                            : Text(order.numberOfPerson.toString() ?? "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold)),
                        order.numberOfPerson == null
                            ? Container()
                            : SizedBox(width: 2.w),
                        order.numberOfPerson == null
                            ? Container()
                            : Text("x",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                        order.numberOfPerson == null
                            ? Container()
                            : SizedBox(width: 6.w),
                        Text("Delivery",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Spacer(),
                        Text(order.total,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
              SizedBox(height: 4.w),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              order.note == "" ? Container() : SizedBox(height: 10),
              Container(
                  child: Text(order.note,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ))),
              order.note == ""
                  ? Container()
                  : Divider(
                      height: 1,
                      color: Colors.black,
                    ),
              order.note == "" ? Container() : SizedBox(height: 4.h),
              Container(
                height: (23.0.h * order.products.length),
                child: ListView.builder(
                    itemCount: order.products.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            order.products[index].quantity.toString(),
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "x",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Container(
                              child: Text(
                                order.products[index].name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          // Spacer(),
                          Text(
                            order.products[index].price.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    }),
              ),
              SizedBox(height: 4.h),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Row(children: [
                  Text(
                    "Total In nok",
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    order.total,
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
