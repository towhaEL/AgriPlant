import 'package:cloud_firestore/cloud_firestore.dart';

class Process {
  late  int processCode;
  final String name;
  final String description;
  final String image;

  Process(
      {required this.processCode,
      required this.name,
      required this.description,
      required this.image});

  // create empty product model
  static Process empty() => Process(processCode: -1, name: '', description: '', image: '');

  // product model to json
  Map<String, dynamic> tojson() {
    return {
      'processCode': processCode,
      'name': name, 
      'description': description, 
      'image': image, 
    };
  }

  // factory method to create UserModel from a firebase document snapshot
  factory Process.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return Process(
        processCode: int.parse(document.id),
        name: data['name'] ?? '', 
        description: data['description'] ?? '', 
        image: data['image'] ?? '', 
        );
    } else {
      return Process.empty();
    }
  }
}
