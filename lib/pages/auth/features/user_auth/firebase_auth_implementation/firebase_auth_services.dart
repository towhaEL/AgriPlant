



import 'package:agriplant/models/user_model.dart';
import 'package:agriplant/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../global/common/toast.dart';


class FirebaseAuthService extends GetxController {
  static FirebaseAuthService get instance => Get.find();

  FirebaseAuth _auth = FirebaseAuth.instance;

  // get authenticated user data
  User? get authUser => _auth.currentUser;
  

  Future<User?> signUpWithEmailAndPassword(String email, String password, String username, String phoneNumber) async {

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      final newUser = UserModel(
        uid: credential.user!.uid,
        fullname: '',
        username: username, 
        email: email, 
        phoneNumber: phoneNumber, 
        profilePicture: "https://docs.near.org/assets/images/user-724b79cd582c0a0944ee750396d6a9e2.png",
        address: '', 
        city: '', 
        postCode: '',
        isAdmin: false,
      );

      final userRepository = Get.put(UserRepository());
      userRepository.saveUserRecord(newUser);

      return credential.user;

    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;

  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      // final controller = Get.put(UserController());
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }

    }
    return null;

  }






}


