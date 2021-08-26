import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/controller/server.dart';
import 'package:smart_chef/model/order.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/smart_chef_icons.dart';

import 'loading_indicator.dart';
import 'zigzag_clipper.dart';

class ClippedOrder extends StatefulWidget {
  final Order order;
  final bool isNotification;
  final bool isDetailsView;
  final Function printt;

  const ClippedOrder({
    Key key,
    @required this.order,
    this.isNotification = true,
    this.isDetailsView = false,
    this.printt,
  }) : super(key: key);

  @override
  _ClippedOrderState createState() => _ClippedOrderState();
}

class _ClippedOrderState extends State<ClippedOrder> {
  GlobalKey _orderKey = GlobalKey();

  int currentMinuteIndex = 0;
  PageController minutesController;
  bool isMaxHeight = false;
  double height = 0;
  double maxHeight = 520;

  bool toKitchenLoading = false;
  bool toDoneLoading = false;
  String img;

  bool undo = false;
  HomeGet homeGet = Get.find();
  static const List<int> minutes = [
    0,
    5,
    10,
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    55,
  ];

  Timer _timer;
  // int _start;

  void startTimer() {
    const oneSec = const Duration(seconds: 60);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          getMinute(
            duration: Duration(
              minutes: widget.order.deliveryTime,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();

    setState(() {});
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print(timeStamp.toString());
      isClipped();
    });
    minutesController = PageController(
      viewportFraction: 0.3,
      initialPage: currentMinuteIndex,
    );
  }

  @override
  void didUpdateWidget(covariant ClippedOrder oldWidget) {
    super.didUpdateWidget(oldWidget);
    isClipped();
  }

  void isClipped() {
    final RenderBox renderBoxRed = _orderKey.currentContext.findRenderObject();
    double _height = renderBoxRed.size.height;
    if (_height >= maxHeight) {
      setState(() {
        isMaxHeight = true;
        height = maxHeight;
      });
    } else {
      height = _height;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 350,
        child: Column(
          children: [
            Container(
              height: 55,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Visibility(
                    visible: !widget.isNotification && !widget.isDetailsView,
                    child: Text(
                      getMinute(
                            duration: Duration(
                              minutes: widget.order.deliveryTime,
                            ),
                          ).toString() +
                          ' min',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Spacer(),
                  Visibility(
                    visible: !widget.isNotification,
                    child: IconButton(
                      icon: Icon(
                        Icons.print,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () => widget.printt(),
                    ),
                  ),
                  Visibility(
                    visible: !widget.isDetailsView,
                    child: IconButton(
                      icon: Icon(
                        isMuted()
                            ? Icons.notifications
                            : Icons.notifications_off,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        homeGet.toggleAlert(
                          stop: !isMuted(),
                          orderCode: widget.order.orderCode,
                        );
                        setState(() {});
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      widget.order.delivery == "delivery"
                          ? Icons.directions_run
                          : SmartChef.dish,
                      color: Colors.white,
                      size: widget.order.delivery == "delivery" ? 30 : 26,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(13),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: getHeaderGradient(),
                ),
              ),
            ),
            Column(children: [
              Container(
                color: greyDEDEDE,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.customerName,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${widget.order.customerMobile}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          // height: G,
                          width: 230,
                          child: Text(
                            "${widget.order.address}",
// widget.order.address.toString().length>40?"${widget.order.address}"+"\n":"${widget.order.address}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Center(
                          child: Text(
                            "#" + widget.order.orderCode ?? "",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: widget.order.isPayed == true
                                    ? Colors.green[400]
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.order.isPayed == true
                                    ? "Betalt"
                                    : "Ikke betalt",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              widget.order.note == ""
                  ? Container()
                  : Container(
                      color: yellowFBD400,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.assignment_outlined),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.order.note ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              Stack(
                key: _orderKey,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: isMaxHeight && widget.isNotification ? 0 : 30),
                    child: ZigZag(
                      isMaxHeight: isMaxHeight,
                      child: Container(
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: isMaxHeight && !widget.isNotification
                                    ? maxHeight - 20
                                    : maxHeight,
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                  bottom: isMaxHeight && !widget.isNotification
                                      ? 100
                                      : 0,
                                ),
                                children: [
                                  ListView.separated(
                                      padding: const EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: widget.order.products == null
                                          ? 0
                                          : widget.order.products.length,
                                      itemBuilder: (_, index) => ticketItem(
                                            product:
                                                widget.order.products[index],
                                          ),
                                      separatorBuilder: (_, index) =>
                                          Container()),
                                  Container(
                                    height: 2,
                                    color: Colors.grey[500],
                                  ),
                                  // SizedBox(height: 5),
                                  // Divider(
                                  //   color: Colors.black,
                                  // ),

                                  Visibility(
                                    visible: widget.isNotification,
                                    child: SizedBox(
                                      height: 165,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Ferdig etter',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                        color: redF55B31,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Text(
                                                          //   getHour(
                                                          //     duration: Duration(
                                                          //       minutes: minutes[currentMinuteIndex] ??
                                                          //           0,
                                                          //     ),
                                                          //   ),
                                                          //   style: TextStyle(
                                                          //     color: Colors.white,
                                                          //     fontWeight:
                                                          //         FontWeight.bold,
                                                          //     fontSize: 25,
                                                          //   ),
                                                          // ),

                                                          SizedBox(width: 4),
                                                          Text(
                                                            "${minutes[currentMinuteIndex]}"
                                                                // getMinute(
                                                                //       duration:
                                                                //           Duration(
                                                                //         minutes:
                                                                //             minutes[currentMinuteIndex] +
                                                                //                     1 ??
                                                                //                 0,
                                                                //       ),
                                                                //     ).toString()
                                                                +
                                                                'min',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 24
                                                                //  getHour() ==
                                                                //             '' ||
                                                                //         getHour() == '-'
                                                                //     ? 25
                                                                //     : 15,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Spacer(),
                                                    Expanded(
                                                      child: Container(
                                                        height: 100,
                                                        // w
                                                        child: PageView(
                                                          controller:
                                                              minutesController,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          onPageChanged:
                                                              (index) {
                                                            setState(() {
                                                              currentMinuteIndex =
                                                                  index;
                                                            });
                                                          },
                                                          children:
                                                              List.generate(
                                                            minutes.length,
                                                            (index) => Text(
                                                              '${minutes[index]}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: index ==
                                                                      currentMinuteIndex
                                                                  ? TextStyle(
                                                                      fontSize:
                                                                          35,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )
                                                                  : TextStyle(
                                                                      fontSize:
                                                                          25,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text('min'),
                                                    // Spacer(),
                                                    SizedBox(width: 5),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: 80,
                                            height: 110,
                                            margin: const EdgeInsets.all(4),
                                            child: Material(
                                              type: MaterialType.transparency,
                                              child: InkWell(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                onTap: () async {
                                                  Server.serverProvider
                                                      .updateOrder(
                                                    data: {
                                                      'order_id':
                                                          widget.order.id,
                                                      'status': 1,
                                                      'delivery_time': minutes[
                                                          currentMinuteIndex],
                                                      "admin_alert":
                                                          "admin note sds"
                                                    },
                                                  ).then((value) {
                                                    if (mounted) {
                                                      setState(() {
                                                        toKitchenLoading =
                                                            false;
                                                      });
                                                    }
                                                  });
                                                  homeGet.pauseAlertForOrder(
                                                      orderCode: widget
                                                          .order.orderCode);
                                                  // widget.printt();
                                                  setState(() {
                                                    toKitchenLoading = true;
                                                  });
                                                },
                                                child: Center(
                                                  child: toKitchenLoading
                                                      ? LoadingIndicator()
                                                      : Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 50,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  green8DC640,
                                                  green476320,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            isMaxHeight || !widget.isNotification
                                ? SizedBox(height: 20)
                                : SizedBox(height: 0),
                            maxHeight - height >= 40 && !widget.isNotification
                                ? SizedBox(height: 40)
                                : SizedBox(height: 0),
                          ],
                        ),
                        // padding: const EdgeInsets.only(bottom: 40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: isMaxHeight
                                ? Radius.circular(0)
                                : Radius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Visibility(
                      visible: !widget.isNotification && !widget.isDetailsView,
                      child: Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.all(10),
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            onTap: () {
                              homeGet.toggleAlert(
                                stop: isMuted(),
                                orderCode: widget.order.orderCode,
                              );
                              toggleUndo();
                              Future.delayed(Duration(seconds: 5), () {
                                if (undo) {
                                  toggleUndo();
                                  toDoneHandler();
                                }
                              });
                            },
                            child: Center(
                              child: undo
                                  ? Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                      size: 50,
                                    )
                                  : toDoneLoading
                                      ? LoadingIndicator()
                                      : Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: undo
                                ? [
                                    yellowFBD400,
                                    yellow7E6A00,
                                  ]
                                : [
                                    green8DC640,
                                    green476320,
                                  ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ]),
          ],
        ),
      ),
    );
  }

  void toggleUndo() {
    if (mounted) {
      setState(() {
        undo = !undo;
      });
    }
  }

  void toDoneHandler() {
    if (mounted) {
      setState(() {
        toDoneLoading = true;
      });
    }
    homeGet.disableAlert(
      orderCode: widget.order.orderCode,
    );
    homeGet.updateOrderStatus(
      data: {
        'order_id': widget.order.id,
        'status':
            DateTime.parse(widget.order.orderTime).isBefore(DateTime.now())
                ? 5
                : widget.order.delivery == "Takeaway"
                    ? 3
                    : 4,
        'delivery_time': minutes[currentMinuteIndex],
        'admin_alert': "admin note sds",
      },
    ).then((value) {
      if (mounted) {
        setState(() {
          toDoneLoading = false;
        });
      }
    });
  }

  List<Color> getHeaderGradient() {
    final DateTime deliverTime = DateTime.parse(widget.order.orderTime)
        .add(Duration(minutes: widget.order.deliveryTime ?? 0));
    if (deliverTime.isAfter(DateTime.now().add(Duration(hours: 2)))) {
      return [
        blue0169D1,
        blue013569,
      ];
    } else if (deliverTime.isBefore(DateTime.now().add(Duration(minutes: 5)))) {
      return [
        redF55B31,
        red7B2E19,
      ];
    }
    return [
      grey383D42,
      grey0B0C0D,
    ];
  }

  Widget ticketItem({Product product}) {
    return Column(
      children: [
        Container(
          height: 2,
          color: Colors.grey[500],
        ),
        Container(
          color: product.changeComp != 0 ? Colors.yellow[100] : Colors.white,
          child: Column(
            children: [
              SizedBox(height: 4),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      child: Center(
                        child: Text(
                          product.quantity.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: product.quantity > 1 ? redF55B31 : grey31393C,
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product.productName}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${product.size}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${product.dough}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${product.spicy}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              // Container(
              //   height: 20,
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     primary: false,
              //     scrollDirection: Axis.horizontal,
              //     itemCount:
              //     product.component.length,
              //     itemBuilder: (_, index) =>
              product.component.length == 0
                  ? Container()
                  : product.changeComp == 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 16),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      product.component
                                          .map((e) => e)
                                          .toList()
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                             
                              product.entrees.length == 0
                                  ? Container()
                                  : Container(
                                      width: 340,
                                      height: 20,
                                      // color: Colors.red,
                                      child: Wrap(
                                        children: [
                                          ...List.generate(
                                            product.entrees.length,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              child: Text(
                                                product.entrees[index],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 285,
                                  child: Wrap(
                                    children: [
                                      ...List.generate(
                                        product.basicComponent.length,
                                        (index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: Text(
                                            product.basicComponent[index]
                                                        ['extra'] ==
                                                    0
                                                ? product.basicComponent[index]
                                                        ['name'] +
                                                    (index ==
                                                            product.basicComponent
                                                                    .length -
                                                                1
                                                        ? ""
                                                        : " -")
                                                : "Extra " +
                                                    product.basicComponent[
                                                        index]['name'] +
                                                    (index ==
                                                                product.basicComponent
                                                                        .length -
                                                                    1
                                                            ? ""
                                                            : " -")
                                                        .toString(),
                                            style: TextStyle(
                                                fontWeight: product
                                                                .basicComponent[
                                                            index]['extra'] ==
                                                        0
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   "Fjern : ",
                                    //   style: TextStyle(
                                    //     fontSize: 15,
                                    //     color: Colors.black,
                                    //     // fontWeight: FontWeight.bold
                                    //   ),
                                    // ),
                                    Container(
                                      width: 340,
                                      child: Wrap(
                                        children: [
                                          ...List.generate(
                                            product.delComponent.length,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              child: Text(
                                                product.delComponent[index]
                                                            ['extra'] ==
                                                        0
                                                    ? product.delComponent[index]
                                                            ['name'] +
                                                        (index ==
                                                                product.delComponent
                                                                        .length -
                                                                    1
                                                            ? ""
                                                            : " -")
                                                    : "Extra " +
                                                        product.delComponent[
                                                            index]['name'] +
                                                        (index ==
                                                                    product.delComponent
                                                                            .length -
                                                                        1
                                                                ? ""
                                                                : " -")
                                                            .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.red),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   height:
                                    //       product.delComponent.length * 15.0,
                                    //   width: 290,
                                    //   child: GridView.builder(
                                    //     padding: EdgeInsets.zero,
                                    //     gridDelegate:
                                    //         SliverGridDelegateWithFixedCrossAxisCount(
                                    //             crossAxisCount: 3,
                                    //             mainAxisSpacing: 5,
                                    //             crossAxisSpacing: 0,
                                    //             childAspectRatio: 5),
                                    //     itemCount: product.delComponent.length,
                                    //     itemBuilder: (context, index) => Text(
                                    //       product.delComponent[index]
                                    //                   ['extra'] ==
                                    //               0
                                    //           ? product.delComponent[index]
                                    //               ['name']
                                    //           : "Extra " +
                                    //               product.delComponent[index]
                                    //                   ['name'],
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           fontSize: 16,
                                    //           color: Colors.red),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   "Legg : ",
                                    //   style: TextStyle(
                                    //     fontSize: 15,
                                    //     color: Colors.black,
                                    //     // fontWeight: FontWeight.bold
                                    //   ),
                                    // ),

                                    Container(
                                      width: 340,
                                      // color: Colors.red,
                                      child: Wrap(
                                        children: [
                                          ...List.generate(
                                            product.newComponent.length,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              child: Text(
                                                product.newComponent[index]
                                                            ['extra'] ==
                                                        0
                                                    ? product.newComponent[index]
                                                            ['name'] +
                                                        (index ==
                                                                product.newComponent
                                                                        .length -
                                                                    1
                                                            ? ""
                                                            : " -")
                                                    : "Extra " +
                                                        product.newComponent[
                                                            index]['name'] +
                                                        (index ==
                                                                    product.newComponent
                                                                            .length -
                                                                        1
                                                                ? ""
                                                                : " -")
                                                            .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: product.newComponent[
                                                                    index]
                                                                ['extra'] ==
                                                            0
                                                        ? Colors.green[900]
                                                        : Colors.black),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 270,
                                      // color: Colors.red,
                                      child: GridView.builder(
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 5,
                                                crossAxisSpacing: 0,
                                                childAspectRatio: 5),
                                        itemCount: product.entrees.length,
                                        itemBuilder: (context, index) => Text(
                                          product.entrees[index],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ))
                          // height: 20,
                          // decoration: BoxDecoration(color: Colors.yellow[100]),
                          ),
            ],
          ),
        ),
      ],
    );
  }

  Widget discountItem({String title, String amount}) {
    final TextStyle style = TextStyle(
      fontSize: 16,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            style: style,
          ),
          Text(
            '$amount,-',
            style: style,
          ),
        ],
      ),
    );
  }

  // String getHour({Duration duration = Duration.zero}) {
  //   String date = DateTime.parse(widget.order.orderTime)
  //       .add(duration)
  //       .difference(DateTime.now())
  //       .toString();
  //   List<String> dateComponents = date.split(':');
  //   String hour = dateComponents[0];

  //   if (hour == '0') {
  //     hour = '';
  //   } else if (hour == '-0') {
  //     hour = '-';
  //   }

  //   return '$hour';
  // }

  String getMinute({Duration duration = Duration.zero}) {
    String date = DateTime.parse(widget.order.orderTime)
        .difference(DateTime.now())
        .toString();
    List<String> dateComponents = date.split(':');
    String minute = dateComponents[1];
//  .add(duration)
    return '$minute';
  }

  bool isMuted() {
    if (homeGet.rangBefore.containsKey(widget.order.orderCode)) {
      return homeGet.rangBefore[widget.order.orderCode].enable;
    }
    return false;
  }
}
