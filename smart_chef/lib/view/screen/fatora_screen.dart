import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_chef/model/order.dart';

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
      width: 300,
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
                      width: 180,
                      height: 50,
                      child: Image.asset(
                        "assets/images/fatora.png",
                        color: Colors.black,
                      ))),
              SizedBox(height: 5),
              Row(children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text(
                  order.customerName + " # " + order.id.toString(),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ]),
              Row(children: [
                Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text(
                  order.customerMobile,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ]),
              SizedBox(height: 5),
              Row(children: [
                Icon(
                  Icons.car_repair,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text(order.delivery,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(width: 20),
                Text(
                  order.numberOfPerson.toString() + " Person",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ]),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(children: [
                  Icon(Icons.history_toggle_off),
                  SizedBox(width: 10),
                  Text(
                    timeOrderRang +
                        "  " +
                        unitTime +
                        "  " +
                        "(${DateFormat('kk:mm').format(timeOrder)})",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              order.delivery == "Takeaway"
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(order.numberOfPerson.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 5),
                          Text("x",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 10),
                          Text("Delivery",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Spacer(),
                          Text(order.total,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              order.note == "" ? Container() : SizedBox(height: 10),
              Container(
                  child: Text(order.note,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ))),
              order.note == ""
                  ? Container()
                  : Divider(
                      height: 1,
                      color: Colors.black,
                    ),
              order.note == "" ? Container() : SizedBox(height: 10),
              Container(
                height: (25.0 * order.products.length),
                child: ListView.builder(
                    itemCount: order.products.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            order.products[index].quantity.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "x",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              child: Text(
                                order.products[index].productName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          // Spacer(),
                          Text(
                            order.products[index].price.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    }),
              ),
              SizedBox(height: 5),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(children: [
                  Text(
                    "Total In nok",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    order.total,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
