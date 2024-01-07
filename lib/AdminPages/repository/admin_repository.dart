
import 'package:agriplant/exceptions/firebase_exceptions.dart';
import 'package:agriplant/exceptions/platform_exceptions.dart';
import 'package:agriplant/models/order.dart';
import 'package:agriplant/models/order_model.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/models/user_model.dart';
import 'package:agriplant/utils/enum/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AdminRepository extends GetxController{
  static AdminRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  // Get all products
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _db.collection('Users').get();
      final list = snapshot.docs.map((document) => UserModel.fromSnapshot(document)).toList();
      return list;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get order code id
  Future<List<OrderModel>> getOrderId(UserModel user) async {
    try {
      final snapshot = await _db.collection('Users').doc(user.uid).collection('Orders').get();
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

  //// Get user order list
  Future<List<Order>> fetchAllOrder(UserModel user) async {
    try {
      final orderList = await getOrderId(user);
      List<Order> OrderModelList = [];
      // product list
      for( var i=0; i<orderList.length; i++) {
        OrderStatus dummyStatus = OrderStatus.Processing;
        final snapshot = await _db.collection('Users').doc(user.uid).collection('Orders').doc(i.toString()).collection('Products').get();
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


  // Function to update single order data from Firestore
  Future<void> updateSingleField(UserModel user, String orderId, Map<String, dynamic> json) async {
    try {
      await _db.collection("Users").doc(user.uid).collection('Orders').doc(orderId.toString()).update(json);
      // showToast(message: 'User profile updated.');
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


}