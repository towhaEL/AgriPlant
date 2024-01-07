import 'package:agriplant/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:agriplant/models/user_model.dart';
import 'package:image_picker/image_picker.dart';


class UserController extends GetxController {
  static UserController get instance => Get.find();
  
  RxBool profileLoading = false.obs;
  RxBool imageUploading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());
  

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }


  /// Fetch user record
  fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
      profileLoading.value = false;
      print(user.isAdmin);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  

  //save user record from provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {

      // first update rx user and then check if user data is already stored, if not store new data
      await fetchUserRecord();


      if (user.value.uid.isEmpty) {
  if (userCredentials != null) {
    // generate username
    final username = UserModel.generateUsername(userCredentials.user!.displayName ?? '');
  
    // Map data
    final user = UserModel(
      uid: userCredentials.user!.uid,
      fullname: userCredentials.user!.displayName ?? '',
      username: username, 
      email: userCredentials.user!.email ?? '', 
      phoneNumber: userCredentials.user!.phoneNumber ?? '', 
      profilePicture: userCredentials.user!.photoURL ??  "https://docs.near.org/assets/images/user-724b79cd582c0a0944ee750396d6a9e2.png", 
      address: '', 
      city: '', 
      postCode: '',
      isAdmin: false,
      );
  
      // save user data
      await userRepository.saveUserRecord(user);
  }
}
    } catch (e) {

    }
  }



  uploadUserProfilePicture() async {
    try {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 512, maxWidth: 512);
  if(image != null) {
    imageUploading.value = true;
    final imageUrl = await userRepository.uploadImage('Users/Images/Profile/', image);
  
    // update user image record
    Map<String, dynamic> json = {'profilePicture': imageUrl};
    await userRepository.updateSingleField(json);
  
    user.value.profilePicture = imageUrl;
    user.refresh();
    imageUploading.value = false;
  }
}  catch (e) {

} finally {
  imageUploading.value = false;
}
  }

  //save user record from provider
  Future<void> saveUserRecordModel(UserModel user) async {
    try {
      await userRepository.saveUserRecord(user);

    } catch (e) {

    }
  }

  // Function to update single data from Firestore
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await userRepository.updateSingleField(json);

    } catch (e) {

    }
  }




}