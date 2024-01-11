import 'dart:async';
import 'dart:math';

import 'package:agriplant/exceptions/firebase_exceptions.dart';
import 'package:agriplant/pages/diseases/disease_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DiseaseRepository extends GetxController{
  static DiseaseRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  // generate random id
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  // Function to fetch user Cart from Firestore based on user id
  Future<List<Disease>> fetchUserBookmark() async {
    try {
      final snapshot = await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('Diseases').get();
      final list = snapshot.docs.map((document) => Disease.fromSnapshot(document)).toList();
      return list;

    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // add product to user's cart
  Future<void> addProductToBookmark(Disease product) async {
    try {
      // String id = product.productCode.toString().padLeft(6, '0');
      await _db.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).collection("Diseases").doc(product.diseaseCode.toString()).set(product.tojson());
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  Future<void> removeSingleBookmarkItem(Disease cartItem) async {
    try {
      await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('Diseases').get().then(
  (querySnapshot) async {
    for (var docSnapshot in querySnapshot.docs) {
      if (int.parse(docSnapshot.id) == cartItem.diseaseCode) {
        await _db.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('Diseases').doc(docSnapshot.id).delete();
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