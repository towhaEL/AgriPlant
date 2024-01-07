import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String name;
  final String imageUrl;
  final int serviceCode;

  Service({
    required this.name,
    required this.imageUrl,
    required this.serviceCode,
  });


  // create empty user model
  static Service empty() => Service(name: '', imageUrl: '', serviceCode: -1,);

  // model to json
  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'serviceCode': serviceCode, 
    };
  }

  // factory method to create Service from a firebase document snapshot
  factory Service.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return Service(
        serviceCode: int.tryParse(document.id) ?? -1,
        name: data['name'] ?? '',
        imageUrl: data['imageUrl'] ?? '', 
        );
    } else {
      return Service.empty();
    }
  }

}
