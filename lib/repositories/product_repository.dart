
import 'package:agriplant/exceptions/firebase_exceptions.dart';
import 'package:agriplant/exceptions/platform_exceptions.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/pages/auth/global/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxController{
  static ProductRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      final snapshot = await _db.collection('Products').get();
      final list = snapshot.docs.map((document) => Product.fromSnapshot(document)).toList();
      return list;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // add new product
  Future<void> addNewProduct(Product product, String id) async {
    try {
      await _db.collection("Products").doc(id).set(product.tojson());
      showToast(message: "Product added succesfully.");
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // search product
//   Future<Product> searchProduct(int productCode) async {
    
//     try {
//       // final snapshot = await _db.collection('Products').where("productCode", isEqualTo: productCode).get();
//       await _db.collection("Products").where("productCode", isEqualTo: productCode).get().then(
//   (querySnapshot) {
//     for (var docSnapshot in querySnapshot.docs) {
//       return Product.fromSnapshot(docSnapshot);
//     }
    
//   },
// );
// return Product.empty();
//     } on FirebaseException catch (e){
//       throw TFirebaseException(e.code).message;
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (e) {
//       throw 'Something went wrong. Please try again';
//     }
//   }

}