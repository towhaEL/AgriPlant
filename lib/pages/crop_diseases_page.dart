
import 'package:agriplant/pages/diseases/classify.dart';
import 'package:agriplant/pages/diseases/disease_model.dart';
import 'package:agriplant/pages/diseases/result_page.dart';
import 'package:agriplant/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class cropDisease extends StatelessWidget {
  const cropDisease({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = Get.put(UserRepository());

    Size size = MediaQuery.of(context).size;
    final Classifier classifier = Classifier();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SpeedDial(
        icon: Icons.camera_alt,
        spacing: 10,
        children: [
          SpeedDialChild(
            child: const FaIcon(
              IconlyLight.image2,
              color: Colors.white,
            ),
            label: "Choose image",
            backgroundColor: Colors.green,
            onTap: () async {
              late double _confidence;
              late Disease _disease;

              await classifier.getDisease(ImageSource.gallery).then((value) async {
                // var name = value![0]["label"];
                // var imagePath = classifier.imageFile.path;
                // var confidence = value[0]['confidence'];
                // print(
                // "Result is $name and Path is $imagePath and confidence is $_confidence");
                final imageUrl = await userRepository.uploadDiseaseImage('Diseases/Images/', classifier.imageFile.path);
                _disease = Disease(
                    name: value![0]["label"],
                    imagePath: imageUrl,
                    confidence: value[0]['confidence'].toString(),
                    dateTime: DateTime.now().toString(),
                    diseaseCode: DateTime.now().hashCode,
                    );

                _confidence = value[0]['confidence'];
              });
              // Check confidence
              if (_confidence > 0.8) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => showResult(disease: _disease, imagePath: classifier.imageFile.path),
                  ),
                );
                // Set disease for Disease Service
                // _diseaseService.setDiseaseValue(_disease);

                // Save disease
                // _hiveService.addDisease(_disease);

                // Navigator.restorablePushNamed(
                //   context,
                //   Suggestions.routeName,
                // );
              } else {
                // Display unsure message
              }
            },
          ),
          SpeedDialChild(
            child: const FaIcon(
              IconlyLight.camera,
              color: Colors.white,
            ),
            label: "Take photo",
            backgroundColor: Colors.green,
            onTap: () async {
              late double _confidence;
              late Disease _disease;
              // var image =
              //     await ImagePicker().pickImage(source: ImageSource.camera);

              await classifier.getDisease(ImageSource.camera).then((value) async {
                // var name = value![0]["label"];
                // var imagePath = classifier.imageFile.path;
                // var confidence = value[0]['confidence'];
                // print(
                //     "Result is $name and Path is $imagePath and confidence is $confidence");
                final imageUrl = await userRepository.uploadDiseaseImage('Diseases/Images/', classifier.imageFile.path);
                _disease = Disease(
                    name: value![0]["label"],
                    imagePath: imageUrl,
                    confidence: value[0]['confidence'].toString(),
                    dateTime: DateTime.now().toString(),
                    diseaseCode: DateTime.now().hashCode,
                    );

                _confidence = value[0]['confidence'];
              });

              // Check confidence
              if (_confidence > 0.8) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => showResult(disease: _disease, imagePath: classifier.imageFile.path),
                  ),
                );
                // Set disease for Disease Service
                // _diseaseService.setDiseaseValue(_disease);

                // Save disease
                // _hiveService.addDisease(_disease);

                // Navigator.restorablePushNamed(
                //   context,
                //   Suggestions.routeName,
                // );
              } else {
                // Display unsure message
              }
            },
          ),
        ],
      ),
      appBar: AppBar(
          title: const Text("Crop diseases solution"),
          backgroundColor: const Color(0xFFF5FFFF)),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/CropDiseasesDetection/images/bg.jpg'),
                fit: BoxFit.cover),
          ),
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height * .15, horizontal: size.width * .1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Instructions",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text(
                          '1',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        'Take/Select a photo of an affected plant by tapping the camera button below',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        '2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                        'Give it a short while before you can get a suggestion of the disease',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          )),
    );
  }
}
