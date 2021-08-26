import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/model/order.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/view/widget/clipped_order.dart';

import '../../PrintImage.dart';
import 'fatora_screen.dart';

class UiImagePainter extends CustomPainter {
  final ui.Image image;

  UiImagePainter(this.image);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // simple aspect fit for the image
    var hr = size.height / image.height;
    var wr = size.width / image.width;

    double ratio;
    double translateX;
    double translateY;
    if (hr < wr) {
      ratio = hr;
      translateX = (size.width - (ratio * image.width)) / 2;
      translateY = 0.0;
    } else {
      ratio = wr;
      translateX = 0.0;
      translateY = (size.height - (ratio * image.height)) / 2;
    }

    canvas.translate(translateX, translateY);
    canvas.scale(ratio, ratio);
    canvas.drawImage(image, new Offset(0.0, 0.0), new Paint());
  }

  @override
  bool shouldRepaint(UiImagePainter other) {
    return other.image != image;
  }
}

class UiImageDrawer extends StatelessWidget {
  final ui.Image image;

  const UiImageDrawer({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: UiImagePainter(image),
    );
  }
}

class Capturer extends StatefulWidget {
  static final Random random = Random();
  final Order order;
  final bool isNotification;
  final bool isDetailsView;

  final GlobalKey<OverRepaintBoundaryState> overRepaintKey;

  Capturer(
      {Key key,
      this.overRepaintKey,
      this.order,
      this.isDetailsView = false,
      this.isNotification = true})
      : super(key: key);

  @override
  _CapturerState createState() => _CapturerState();
}

class _CapturerState extends State<Capturer> {
  GlobalKey<OverRepaintBoundaryState> globalKey = GlobalKey();
  ui.Image image;
  ByteData byteData;
  String bs64;
  Uint8List uint8List;
  HomeGet homeGet = Get.find();
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: OverRepaintBoundary(
              key: globalKey,
              child: RepaintBoundary(
                child: Visibility(
                  child: Container(
                    child: FatoraScreen(order: widget.order),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 350,
            height: 450,
            color: grey2E3134,
          ),
          ClippedOrder(
            order: widget.order,
            isNotification: widget.isNotification,
            isDetailsView: widget.isDetailsView,
            key: widget.key,
            printt: () async {
              var renderObject = globalKey.currentContext.findRenderObject();
              RenderRepaintBoundary boundary = renderObject;
              ui.Image captureImage = await boundary.toImage();
              byteData =
                  await captureImage.toByteData(format: ui.ImageByteFormat.png);
              uint8List = byteData.buffer.asUint8List();
              bs64 = base64Encode(uint8List);
              if (homeGet.isconnected.value == false) {
                Get.defaultDialog(
                    title: "Velg skriveren",
                    onCancel: () {
                      navigator.pop();
                    },
                    content: PrintImage(
                      img: bs64,
                    ));
              } else {
                Map<String, dynamic> config = Map();
                config['width'] = 40;
                config['height'] = 70;
                config['gap'] = 1;
                List<LineText> list1 = List();
                list1.add(LineText(
                  type: LineText.TYPE_IMAGE,
                  x: 10,
                  y: 10,
                  content: bs64,
                ));

                await bluetoothPrint.printReceipt(config, list1);
              }
            },
          ),
        ],
      ),
    );
  }
}

class OverRepaintBoundary extends StatefulWidget {
  final Widget child;

  const OverRepaintBoundary({Key key, this.child}) : super(key: key);

  @override
  OverRepaintBoundaryState createState() => OverRepaintBoundaryState();
}

class OverRepaintBoundaryState extends State<OverRepaintBoundary> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
