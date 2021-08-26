class Order {
  int id;
  String orderCode;
  String customerName;
  var customerMobile;
  String orderTime;
  int deliveryTime;
  String note;
  int status;
  String delivery;
  String address;
  bool isPayed;
  String total;
  int numberOfPerson;
  List<Product> products;

  Order({
    this.id,
    this.orderCode,
    this.note,
    this.status,
    this.delivery,
    this.deliveryTime,
    this.isPayed = false,
    this.total,
    this.address,
    this.numberOfPerson,
    this.orderTime,
    this.customerName,
    this.products,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['order_id'];
    orderCode = json['code'];
    note = json['note'];
    status = json['status']['id'];
    delivery = json['delivery']['type'].toString();
    address = json['delivery']['data']['address_text'].toString();
    isPayed = json['payment']['is_payment'] == 1 ? true : false;
    total = json['total'].toString();
    deliveryTime = json['admin']['delivery_time'];
    orderTime = json['admin']['delivery_date'];
    // json['date'];
    customerName = json['customer']['name'];
    customerMobile = json['customer']['mobile'];
    if (json['product_list'].length != 0) {
      products = new List<Product>();
      json['product_list'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'id: $id, code: $orderCode, status: $status';
  }
}

class Product {
  String productName;
  String size;
  String dough;
  String spicy;
  List<String> component = new List<String>();
  List<Map> basicComponent = new List<Map>();
  List<Map> newComponent = new List<Map>();
  List<Map> delComponent = new List<Map>();
  List<String> entrees = new List<String>();
  int quantity;
  int changeComp;
  int price;

  Product({
    this.productName,
    this.size,
    this.dough,
    this.spicy,
    this.quantity,
    this.price,
    this.changeComp,
    this.delComponent = const [],
    this.newComponent = const [],
    this.basicComponent = const [],
    this.component = const [],
    this.entrees = const [],
  });

  Product.fromJson(Map<String, dynamic> json) {
    productName = json['name'];
    size = json['size'];
    dough = json['dough'];
    spicy = json['spicy'];
    quantity = json['qty'];
    price = json['item_total'];
    changeComp = json['change_comp'];
    if (json['data'][0]['component'].length != 0) {
      json['data'][0]['component'].forEach((v) {
        component.add(v);
      });
      if (json['data'][0]['basic_component'].length != 0) {
        json['data'][0]['basic_component'].forEach((v) {
          basicComponent.add(v);
        });}

        if (json['data'][0]['new_component'].length != 0) {
          json['data'][0]['new_component'].forEach((v) {
            newComponent.add(v);
          });
        }
        if (json['data'][0]['del_component'].length != 0) {
          json['data'][0]['del_component'].forEach((v) {
            delComponent.add(v);
          });
        }
        if (json['data'][0]['entrees'].length != 0) {
          json['data'][0]['entrees'].forEach((v) {
            entrees.add(v);
          });
        }
      }
    }
  }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     // data['id'] = this.id;
//     // data['order_id'] = this.orderId;
//     // data['product_id'] = this.productId;
//     data['name'] = this.productName;
//     data['qty'] = this.quantity;
//     data['price'] = this.price;
//    if (json['product_list'].length != 0) {
//       products = new List<Product>();
//       json['product_list'].forEach((v) {
//         products.add(new Product.fromJson(v));
//       });
//     }    // data['options'] = this.options;
//     // data['type'] = this.type;
//     return data;
//   }
// }

// class  Options {
//   String type;
//   String size;

//   Options({
//     this.type,
//     this.size,
//   });

//   Options.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     size = json['Size'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['type'] = this.type;
//     data['Size'] = this.size;
//     return data;
//   }
// }
