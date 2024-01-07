

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullname;
  final String username;
  final String email;
  final String phoneNumber;
  String profilePicture;
  String address;
  String city;
  String postCode;
  bool isAdmin;
  
  UserModel({
    required this.uid,
    required this.fullname, 
    required this.username, 
    required this.email, 
    required this.phoneNumber,
    required this.profilePicture,
    required this.address, 
    required this.city,
    required this.postCode,
    required this.isAdmin,
    });

  // String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber); 
  static String generateUsername(fullname) {
    List<String> nameParts = fullname.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length>1? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = "cwt_$camelCaseUsername"; // "csw_" as prefix
    return usernameWithPrefix;
  }

  // create empty user model
  static UserModel empty() => UserModel(uid: '',fullname: '', username: '', email: '', phoneNumber: '', profilePicture: '', address: '', city: '', postCode: '', isAdmin: false);

  // user model to json
  Map<String, dynamic> tojson() {
    return {
      'uid': uid,
      'fullname': fullname,
      'username': username, 
      'email': email, 
      'phoneNumber': phoneNumber, 
      'profilePicture': profilePicture,
      'address': address,
      'city': city,
      'postCode': postCode,
      'isAdmin': isAdmin,
    };
  }

  // factory method to create UserModel from a firebase document snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        uid: document.id,
        fullname: data['fullname'] ?? '',
        username: data['username'] ?? '', 
        email: data['email'] ?? '', 
        phoneNumber: data['phoneNumber'] ?? '', 
        profilePicture: data['profilePicture'] ?? '', 
        address: data['address'] ??  '', 
        city: data['city'] ??  '', 
        postCode: data['postCode'] ??  '',
        isAdmin: (data['isAdmin']) ?? false,
        );
    } else {
      return UserModel.empty();
    }
  }

}