import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/controller/server.dart';
import 'package:smart_chef/model/order.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/smart_chef_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  double maxHeight = 320;

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
        width: 90.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80.h,
              child: Row(
                children: [
                  SizedBox(width: 6.w),
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
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  Spacer(),
                  // Visibility(
                  //   visible: !widget.isNotification,
                  //   child: IconButton(
                  //     icon: Icon(
                  //       Icons.print,
                  //       color: Colors.white,
                  //       size: 15,
                  //     ),
                  //     onPressed: () => widget.printt(),
                  //   ),
                  // ),
                  Visibility(
                    visible: !widget.isDetailsView,
                    child: IconButton(
                      icon: Icon(
                        isMuted()
                            ? Icons.notifications
                            : Icons.notifications_off,
                        color: Colors.white,
                        size: 16,
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
                      size: widget.order.delivery == "delivery" ? 20 : 18,
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
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
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
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          '${widget.order.customerMobile}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          child: Text(
                            "${widget.order.address}",
                            style: TextStyle(
                              fontSize: 14.sp,
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
                              fontSize: 14.sp,
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
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                widget.order.isPayed == true
                                    ? "Betalt"
                                    : "Ikke betalt",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 14.sp,
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
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              widget.order.note ?? '',
                              style: TextStyle(
                                fontSize: 14.sp,
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
                        bottom:
                            isMaxHeight && widget.isNotification ? 0 : 10.h),
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
                                      ? 80.h
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
                                    height: 2.h,
                                    color: Colors.grey[500],
                                  ),
                                  // SizedBox(height: 5),
                                  // Divider(
                                  //   color: Colors.black,
                                  // ),

                                  Visibility(
                                    visible: widget.isNotification,
                                    child: SizedBox(
                                      height: 150.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10.h),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Ferdig etter',
                                                      style: TextStyle(
                                                          fontSize: 20.sp),
                                                    ),
                                                    SizedBox(width: 10.w),
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

                                                          SizedBox(width: 3.w),
                                                          Text(
                                                            "${minutes[currentMinuteIndex]}" +
                                                                'min',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.sp
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
                                                SizedBox(height: 6.h),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Spacer(),
                                                    Expanded(
                                                      child: Container(
                                                        height: 50.h,
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
                                                                          18.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )
                                                                  : TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5.w),
                                                    Text('min'),
                                                    // Spacer(),
                                                    SizedBox(width: 5.w),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Container(
                                            width: 20.w,
                                            height: 110.h,
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
                        width: 20.w,
                        height: 50.h,
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
                                      size: 30,
                                    )
                                  : toDoneLoading
                                      ? LoadingIndicator()
                                      : Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 30,
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
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      // height: 33.w,
                      // width: 33.h,
                      radius: 16.r,
                      backgroundColor:
                          product.quantity > 1 ? redF55B31 : grey31393C,
                      child: Center(
                        child: Text(
                          product.quantity.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // decoration: BoxDecoration(
                      //   color: product.quantity > 1 ? redF55B31 : grey31393C,
                      //   borderRadius: BorderRadius.all(Radius.circular(22)),
                      // ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product.name}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Text(
                                '${product.size}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${product.dough}',
                                style: TextStyle(
                                  fontSize: 14.sp,
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
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                  // height: 100,
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      itemCount: product.data.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (_, index2) => product.data.length == 0
                          ? Container()
                          : product.changeComp == 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.h, horizontal: 16.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      product.name ==
                                              product.data[index2].productName
                                          ? Container()
                                          : Text(
                                              '${product.data[index2].productName}',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                      product.data[index2].component.length == 0
                                          ? Container()
                                          : Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    product
                                                        .data[index2].component
                                                        .map((e) => e)
                                                        .toList()
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      SizedBox(height: 4.h),
                                      product.data[index2].entrees.length == 0
                                          ? Container()
                                          : Column(
                                              children: [
                                                Container(
                                                  width: 200.w,
                                                  height: 16.h,
                                                  // color: Colors.red,
                                                  child: Wrap(
                                                    children: [
                                                      ...List.generate(
                                                        product.data[index2]
                                                            .entrees.length,
                                                        (index) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      2),
                                                          child: Text(
                                                            product.data[index2]
                                                                .entrees[index],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.sp,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      child: Padding(
                                    padding: EdgeInsets.only(left: 4.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 155.w,
                                          child: Wrap(
                                            children: [
                                              ...List.generate(
                                                product.data[0].basicComponent
                                                    .length,
                                                (index) => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  child: Text(
                                                    product.data[index2].basicComponent[
                                                                    index]
                                                                ['extra'] ==
                                                            0
                                                        ? product.data[index2]
                                                                    .basicComponent[index]
                                                                ['name'] +
                                                            (index == product.data[0].basicComponent.length - 1
                                                                ? ""
                                                                : " -")
                                                        : "Extra " +
                                                            product.data[index2]
                                                                    .basicComponent[
                                                                index]['name'] +
                                                            (index == product.data[0].basicComponent.length - 1
                                                                    ? ""
                                                                    : " -")
                                                                .toString(),
                                                    style: TextStyle(
                                                        fontWeight: product
                                                                        .data[
                                                                            index2]
                                                                        .basicComponent[index]
                                                                    ['extra'] ==
                                                                0
                                                            ? FontWeight.normal
                                                            : FontWeight.bold,
                                                        fontSize: 14.sp,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16.h,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   "Fjern : ",
                                            //   style: TextStyle(
                                            //     fontSize: 15,
                                            //     color: Colors.black,
                                            //     // fontWeight: FontWeight.bold
                                            //   ),
                                            // ),
                                            product.data[index2].delComponent
                                                        .length ==
                                                    0
                                                ? Container()
                                                : Container(
                                                    width: 200.w,
                                                    child: Wrap(
                                                      children: [
                                                        ...List.generate(
                                                          product
                                                              .data[index2]
                                                              .delComponent
                                                              .length,
                                                          (index) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        2),
                                                            child: Text(
                                                              product.data[index2].delComponent[
                                                                              index]
                                                                          [
                                                                          'extra'] ==
                                                                      0
                                                                  ? product.data[0].delComponent[
                                                                              index]
                                                                          [
                                                                          'name'] +
                                                                      (index == product.data[0].delComponent.length - 1
                                                                          ? ""
                                                                          : " -")
                                                                  : "Extra " +
                                                                      product.data[index2].delComponent[
                                                                              index]
                                                                          [
                                                                          'name'] +
                                                                      (index == product.data[index2].delComponent.length - 1
                                                                              ? ""
                                                                              : " -")
                                                                          .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14.sp,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6.h,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            product.data[index2].newComponent
                                                        .length ==
                                                    0
                                                ? Container()
                                                : Container(
                                                    width: 85.w,
                                                    // color: Colors.red,
                                                    child: Wrap(
                                                        children: List.generate(
                                                      product.data[index2]
                                                          .newComponent.length,
                                                      (index) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 1),
                                                        child: Text(
                                                          product.data[index2]
                                                                          .newComponent[index]
                                                                      [
                                                                      'extra'] ==
                                                                  0
                                                              ? product.data[index2].newComponent[
                                                                          index]
                                                                      ['name'] +
                                                                  (index ==
                                                                          product.data[index2].newComponent.length -
                                                                              1
                                                                      ? ""
                                                                      : " -")
                                                              : "Extra " +
                                                                  product
                                                                          .data[0]
                                                                          .newComponent[index]
                                                                      ['name'] +
                                                                  (index == product.data[0].newComponent.length - 1
                                                                          ? ""
                                                                          : " -")
                                                                      .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14.sp,
                                                              color: product.data[index2].newComponent[
                                                                              index]
                                                                          [
                                                                          'extra'] ==
                                                                      0
                                                                  ? Colors.green[
                                                                      900]
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    )),
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 14.h,
                                        ),
                                        product.data[index2].entrees.length == 0
                                            ? Container()
                                            : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 14.h,
                                                    width: 170.w,
                                                    // color: Colors.red,
                                                    child: GridView.builder(
                                                      padding: EdgeInsets.zero,
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 2,
                                                              mainAxisSpacing:
                                                                  5,
                                                              crossAxisSpacing:
                                                                  0,
                                                              childAspectRatio:
                                                                  5),
                                                      itemCount: product
                                                          .data[index2]
                                                          .entrees
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Text(
                                                        product.data[index2]
                                                            .entrees[index],
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
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
                                  ))),
            ],
          ),
        ),
      ],
    );
  }

  Widget discountItem({String title, String amount}) {
    final TextStyle style = TextStyle(
      fontSize: 14.sp,
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
