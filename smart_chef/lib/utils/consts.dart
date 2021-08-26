

import 'package:smart_chef/model/dashboard_model.dart';
import 'package:smart_chef/model/order.dart';

const List<String> days = [
  'mandag',
  'tirsdag',
  'onsdag',
  'torsdag',
  'fredag',
  'lørdag',
  'søndag',
];

const List<String> months = [
  'januar',
  'februar',
  'mars',
  'april',
  'mai',
  'juni',
  'juli',
  'august',
  'september',
  'oktober',
  'november',
  'desember',
];

// DashboardModel staticDashboardModel = DashboardModel(
//   lateOrders: 5,
//   countOrders: 5,
//   newOrders: [
//     Order(
//       id: 1,
//       orderTime: '2020-12-19 15:32:02.657460',
//       note: 'Hi I want ...',
//       customerName: 'basel A.',
//       orderCode: '#123456',
//       status: 1,
//       // delivery: ,
//       total: '500,-',
//       numberOfPerson: 2,
//       products: [
//         Product(
//           id: 100,
//           productName: 'Jaz Maz',
//           quantity: 2,
//           orderId: 1,
//         ),
//         Product(
//           id: 101,
//           productName: 'Maqloubba',
//           quantity: 1,
//           orderId: 1,
//         ),
//         Product(
//           id: 102,
//           productName: 'Shawarma',
//           quantity: 3,
//           orderId: 1,
//         ),
//       ],
//     ),
//     Order(
//       id: 1,
//       orderTime: '2020-12-19 15:33:02.657460',
//       note: 'Hi I want ...',
//       customerName: 'basel A.',
//       orderCode: '#123456',
//       status: 1,
//       // delivery: false,
//       total: '500,-',
//       numberOfPerson: 2,
//       products: [
//         Product(
//           id: 100,
//           productName: 'Jaz Maz',
//           quantity: 2,
//           orderId: 1,
//         ),
//         Product(
//           id: 101,
//           productName: 'Maqloubba',
//           quantity: 1,
//           orderId: 1,
//         ),
//         Product(
//           id: 102,
//           productName: 'Shawarma',
//           quantity: 3,
//           orderId: 1,
//         ),
//       ],
//     ),
//     Order(
//       id: 1,
//       orderTime: '2020-12-19 15:35:02.657460',
//       note: 'Hi I want ...',
//       customerName: 'basel A.',
//       orderCode: '#123456',
//       status: 1,
//       // delivery: false,
//       total: '500,-',
//       numberOfPerson: 2,
//       products: [
//         Product(
//           id: 100,
//           productName: 'Jaz Maz',
//           quantity: 2,
//           orderId: 1,
//         ),
//         Product(
//           id: 101,
//           productName: 'Maqloubba',
//           quantity: 1,
//           orderId: 1,
//         ),
//         Product(
//           id: 102,
//           productName: 'Shawarma',
//           quantity: 3,
//           orderId: 1,
//         ),
//       ],
//     ),
//   ],
//   workingOrders: [],
// );
