import 'dart:math';

import 'package:agriplant/exceptions/firebase_exceptions.dart';
import 'package:agriplant/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CartRepository extends GetxController{
  static CartRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  // generate random id
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  // Function to fetch user Cart from Firestore based on user id
  Future<List<Product>> fetchUserCart() async {
    try {
      final snapshot = await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('cart').get();
      final list = snapshot.docs.map((document) => Product.fromCartSnapshot(document)).toList();
      return list;

    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // add product to user's cart
  Future<void> addProductToCart(Product product) async {
    try {
      String id = product.productCode.toString().padLeft(6, '0');
      await _db.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).collection("cart").doc(id+'-'+getRandomString(15)).set(product.tojson());
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> removeCartItem(Product cartItem) async {
    try {
      await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('cart').get().then(
  (querySnapshot) {
    for (var docSnapshot in querySnapshot.docs) {
      if (int.parse(docSnapshot.id.substring(0, 6)) == cartItem.productCode) {
        _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('cart').doc(docSnapshot.id).delete();
      }
    }
  },
  onError: (e) => print("Error completing: $e"),
);

    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  Future<void> removeSingleCartItem(Product cartItem) async {
    try {
      await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('cart').get().then(
  (querySnapshot) async {
    for (var docSnapshot in querySnapshot.docs) {
      if (int.parse(docSnapshot.id.substring(0, 6)) == cartItem.productCode) {
        await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('cart').doc(docSnapshot.id).delete();
        break;
      }
    }
  },
  onError: (e) => print("Error completing: $e"),
);

    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> removeWholeCart() async {
    try {
      await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('cart').get().then(
  (querySnapshot) async {
    for (var docSnapshot in querySnapshot.docs) {
      await docSnapshot.reference.delete();
    }
  },
  onError: (e) => print("Error completing: $e"),
);

    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

}