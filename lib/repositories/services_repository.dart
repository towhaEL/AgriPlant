import 'package:agriplant/exceptions/firebase_exceptions.dart';
import 'package:agriplant/exceptions/platform_exceptions.dart';
import 'package:agriplant/models/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ServiceRepository extends GetxController{
  static ServiceRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  // Get all services
  Future<List<Service>> getAllServices() async {
    try {
      final snapshot = await _db.collection('Services').get();
      final list = snapshot.docs.map((document) => Service.fromSnapshot(document)).toList();
      return list;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

}