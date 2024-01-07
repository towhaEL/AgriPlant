import 'package:agriplant/models/product.dart';
import 'package:agriplant/utils/enum/order.dart';

class Order {
  final String id;
  final List<Product> products;
  final DateTime orderingDate;
  final DateTime deliveringDate;
  final OrderStatus status;

  Order(
      {required this.id,
      required this.products,
      required this.orderingDate,
      required this.deliveringDate,
      required this.status});


  // create empty product model
  static Order empty() => Order(id: 'id', products: [], orderingDate: DateTime.now(), deliveringDate: DateTime.now(), status: OrderStatus.Picking);

  // product model to json
  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'products': products,
      'orderingDate': orderingDate, 
      'deliveringDate': deliveringDate, 
      'status': status, 
    };
  }



  // factory method to create OrderModel from a firebase document snapshot
  // factory Order.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
  //   if (document.data() != null) {
  //     final data = document.data()!;
  //     return Order(
  //       id: (document.id),
  //       orderingDate: data['orderingDate'] ?? '',
  //       deliveringDate: data['deliveringDate'] ?? '', 
  //       status: data['description'] ?? '', 
  //       products: [], 
  //       );
  //   } else {
  //     return Order.empty();
  //   }
  // }


}
