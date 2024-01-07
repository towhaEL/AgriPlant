import 'dart:math';

import 'package:agriplant/exceptions/firebase_exceptions.dart';
import 'package:agriplant/models/order_model.dart';
import 'package:agriplant/exceptions/platform_exceptions.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/models/order.dart';
import 'package:agriplant/repositories/cart_repository.dart';
import 'package:agriplant/utils/enum/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController{
  static OrderRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;
  final cartRepository = Get.put(CartRepository());

  // generate random id
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  // Get order code id
  Future<List<OrderModel>> getOrderId() async {
    try {
      final snapshot = await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('Orders').get();
      final list = snapshot.docs.map((document) => OrderModel.fromSnapshot(document)).toList();
      return list;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  // convert cart to order
  Future<void> cartToOrder(OrderModel order, List<Product> cartItems, int orderId) async {
    try {
      await _db.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).collection("Orders").doc(orderId.toString()).set(order.tojson());
      // final snapshot = await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('cart').get();
      for (var product in cartItems) {
        String enProductCode = product.productCode.toString().padLeft(6, '0');
        await _db.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).collection("Orders").doc(orderId.toString()).collection('Products').doc(enProductCode+'-'+getRandomString(15)).set(product.tojson());
      }

      // delete cart
      await cartRepository.removeWholeCart();
      
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //// Get order list
  Future<List<Order>> fetchAllOrder() async {
    try {
      final orderList = await getOrderId();
      List<Order> OrderModelList = [];
      // product list
      for( var i=0; i<orderList.length; i++) {
        OrderStatus dummyStatus = OrderStatus.Processing;
        final snapshot = await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('Orders').doc(i.toString()).collection('Products').get();
        final productList =  snapshot.docs.map((document) => Product.fromCartSnapshot(document)).toList();
        switch(orderList[i].status) {
          case 'Processing':
            dummyStatus = OrderStatus.Processing;
            break;
          case 'Picking':
            dummyStatus = OrderStatus.Picking;
            break;
          case 'Shipping':
            dummyStatus = OrderStatus.Shipping;
            break;
          case 'Delivered':
            dummyStatus = OrderStatus.Delivered;
            break;
        }
        final dummyOrder = Order(
          id: i.toString(), 
          products: productList,
          orderingDate: DateTime.parse(orderList[i].orderingDate), 
          deliveringDate: DateTime.parse(orderList[i].deliveringDate), 
          status: dummyStatus,
          );
        OrderModelList.add(dummyOrder);
      }
      return OrderModelList;

    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

}