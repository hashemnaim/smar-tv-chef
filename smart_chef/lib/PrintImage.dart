import 'dart:async';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_home.dart';

class PrintImage extends StatefulWidget {
  final String img;
  PrintImage({this.img});
  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<PrintImage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  HomeGet homeGet = Get.find();

  bool _connected = false;
  BluetoothDevice _device;
  String tips = 'ingen enhetskobling';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      print('cur enhetsstatus : $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'koble suksess';
            print(tips);
            homeGet.isconnected.value = true;
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'koble fra suksess';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
        homeGet.isconnected.value=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(tips),
            ),
          ],
        ),
        StreamBuilder<List<BluetoothDevice>>(
          stream: bluetoothPrint.scanResults,
          initialData: [],
          builder: (c, snapshot) => Column(
            children: snapshot.data
                .map((d) => ListTile(
                      title: Text(d.name ?? ''),
                      subtitle: Text(d.address),
                      onTap: () async {
                        setState(() {
                          _device = d;
                        });
                      },
                      trailing: _device != null && _device.address == d.address
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : null,
                    ))
                .toList(),
          ),
        ),
        Divider(),
        Container(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
          child: Row(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    child: Text('koble'),
                    onPressed: _connected
                        ? null
                        : () async {
                            if (_device != null && _device.address != null) {
                              await bluetoothPrint.connect(_device);
                              homeGet.isconnected.value = true;
                            } else {
                              setState(() {
                                tips = 'velg enhet';
                              });
                              print('velg enhet');
                            }
                          },
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
              OutlineButton(
                child: Text('skrive ut'),
                onPressed: _connected
                    ? () async {
                        Map<String, dynamic> config = Map();
                        config['width'] = 40;
                        config['height'] = 70;
                        config['gap'] = 2;

                        List<LineText> list1 = List();

                        list1.add(LineText(
                          type: LineText.TYPE_IMAGE,
                          x: 10,
                          y: 10,
                          content: widget.img,
                        ));

                        await bluetoothPrint.printLabel(config, list1);
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context).pop(true);
                        });
                      }
                    : null,
              ),
              SizedBox(width: 8),
            ],
          ),
        )
      ],
    ));
  }
}
