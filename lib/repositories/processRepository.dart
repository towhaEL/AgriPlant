
import 'package:agriplant/exceptions/firebase_exceptions.dart';
import 'package:agriplant/exceptions/platform_exceptions.dart';
import 'package:agriplant/pages/auth/global/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/process.dart';

class ProcessRepository extends GetxController{
  static ProcessRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  // Get all Process s
  Future<List<Process>> getAllProducts() async {
    try {
      final snapshot = await _db.collection('Cultivation Process').get();
      final list = snapshot.docs.map((document) => Process.fromSnapshot(document)).toList();
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
  Future<void> addNewProduct(Process product, String id) async {
    try {
      await _db.collection("Cultivation Process").doc(id).set(product.tojson());
      showToast(message: "Process added succesfully.");
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  // Function to fetch user Cart from Firestore based on user id
  Future<List<Process>> fetchUserBookmark() async {
    try {
      final snapshot = await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('Processes').get();
      final list = snapshot.docs.map((document) => Process.fromSnapshot(document)).toList();
      return list;

    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // add product to user's cart
  Future<void> addProductToBookmark(Process product) async {
    try {
      // String id = product.productCode.toString().padLeft(6, '0');
      await _db.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).collection("Processes").doc(product.processCode.toString()).set(product.tojson());
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  Future<void> removeSingleBookmarkItem(Process cartItem) async {
    try {
      await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('Processes').get().then(
  (querySnapshot) async {
    for (var docSnapshot in querySnapshot.docs) {
      if (int.parse(docSnapshot.id) == cartItem.processCode) {
        await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('Processes').doc(docSnapshot.id).delete();
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



}