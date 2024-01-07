import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final int orderId;
  final String orderingDate;
  final String deliveringDate;
  final String status;

  OrderModel({required this.orderId, required this.orderingDate, required this.deliveringDate, required this.status});

  static OrderModel empty() => OrderModel(orderId: -1, orderingDate: DateTime.now().toString(), deliveringDate: DateTime.now().toString(), status: '');

  // product model to json
  Map<String, dynamic> tojson() {
    return {
      'orderId': orderId,
      'orderingDate': orderingDate, 
      'deliveringDate': deliveringDate, 
      'status': status, 
    };
  }


  // factory method to create orderModel from a firebase document snapshot
  factory OrderModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return OrderModel(
        orderId: int.parse(document.id),
        status: data['status'] ?? '',
        deliveringDate: data['deliveringDate'] ?? '', 
        orderingDate: data['orderingDate'] ?? '', 
        );
    } else {
      return OrderModel.empty();
    }
  }

}