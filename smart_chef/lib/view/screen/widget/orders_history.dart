import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_home.dart';
import 'package:smart_chef/controller/server.dart';
import 'package:smart_chef/model/order.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/view/widget/loading_indicator.dart';
import '../canves.dart';

class OrdersHistory extends StatelessWidget {
  static const TextStyle _style = TextStyle(
    color: Colors.white,
    fontSize: 21,
    fontWeight: FontWeight.bold,
  );
  HomeGet homeGet = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => 
    homeGet.dashboardModel.value.ordersHistory.isEmpty?
    Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Orders History',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  FlatButton(
                    color: Colors.white,
                    onPressed: () => Server.serverProvider.dashboardContent(),
                    child: Text('RETRY'),
                  ),
                ],
              ):
  
    homeGet.dashboardModel.value.ordersHistory.length==0
        ? 
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Orders History',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  FlatButton(
                    color: Colors.white,
                    onPressed: () => Server.serverProvider.dashboardContent(),
                    child: Text('RETRY'),
                  ),
                ],
              )
  
            // LoadingIndicator(
            //     height: 25,
            //     width: 25,
            //     margin: EdgeInsets.only(right: 10),
            //   )
            
        : RefreshIndicator(
            onRefresh: () {
              homeGet.getDashboard();
              return Future.value(true);
            },
            child: Obx(
              () => ListView(
                children: [
                  DataTable(
                    dataRowHeight: 70,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          '#ordernummer',
                          style: _style,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Kundenavn',
                          style: _style,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Type',
                          style: _style,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Annet',
                          style: _style,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Totalt',
                          style: _style,
                        ),
                      ),
                    ],
                    rows: homeGet.dashboardModel.value.ordersHistory.length == 0
                        ? Container()
                        : List<DataRow>.generate(
                            homeGet.dashboardModel.value.ordersHistory.length,
                            (index) => DataRow(
                              color: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                // All rows will have the same selected color.
                                if (states.contains(MaterialState.selected))
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.08);
                                if (index % 2 == 0)
                                  return Colors.grey.withOpacity(0.3);
                                return null;
                              }),
                              cells: [
                                DataCell(
                                  Text(
                                    '#${homeGet.dashboardModel.value.ordersHistory[index].orderCode}',
                                    style: _style,
                                  ),
                                  onTap: () => showDetails(
                                      order: homeGet.dashboardModel.value
                                          .ordersHistory[index]),
                                ),
                                DataCell(
                                  Text(
                                    homeGet.dashboardModel.value
                                        .ordersHistory[index].customerName,
                                    style: _style,
                                  ),
                                  onTap: () => showDetails(
                                      order: homeGet.dashboardModel.value
                                          .ordersHistory[index]),
                                ),
                                DataCell(
                                  Text(
                                    homeGet.dashboardModel.value
                                        .ordersHistory[index].delivery,
                                    style: _style,
                                  ),
                                  onTap: () => showDetails(
                                      order: homeGet.dashboardModel.value
                                          .ordersHistory[index]),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      Visibility(
                                        visible: homeGet.dashboardModel.value
                                                .ordersHistory[index].status ==
                                            6,
                                        child:
                                            statusIndicator(color: redC90D13),
                                      ),
                                      Visibility(
                                        visible: homeGet.dashboardModel.value
                                                .ordersHistory[index].status ==
                                            5,
                                        child:
                                            statusIndicator(color: green8DC640),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    showDetails(
                                      order: homeGet.dashboardModel.value
                                          .ordersHistory[index]);
                                          },
                                ),
                                DataCell(
                                  Text(
                                    '${homeGet.dashboardModel.value.ordersHistory[index].total},-',
                                    style: _style,
                                  ),
                                  onTap: () { 
                                    
                                    showDetails(
                                      order: homeGet.dashboardModel.value.ordersHistory[index]);
                                      },
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            )));
  }

  Widget statusIndicator({Color color}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }

  void showDetails({@required Order order}) {
    showDialog(
      context: Get.context,
      builder: (_) => Dialog(
        child: orderItem(order: order),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget orderItem({Order order}) {
    return Capturer(
      isNotification: false,
      isDetailsView: true,
      order: order,
    );
  }
}
