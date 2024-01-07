import 'dart:io';

import 'package:agriplant/pages/diseases/disease_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class showResult extends StatelessWidget {
  const showResult({super.key, required this.disease});
  final Disease disease;

  @override
  Widget build(BuildContext context) {
    List<String> strarray = disease.name.split(" ");
    String link = strarray.join("+");
    final Uri url = Uri.parse('https://www.google.com/search?q=' + link);
    Future<void> _launchUrl() async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Possible condition"),
        // backgroundColor: const Color(0xFFF5FFFF),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {}, icon: const Icon(IconlyBroken.bookmark)),
          )
        ],
      ),
      body: Container(
          child: Padding(
        padding: EdgeInsets.all((0.02 * size.height)),
        child: Column(
          children: [
            Flexible(
              child: Center(
                child: CircleAvatar(
                  radius: size.width * 0.3,
                  backgroundImage: Image.file(
                    File(disease.imagePath),
                    fit: BoxFit.cover,
                  ).image,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  disease.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                IconButton(
                  onPressed: _launchUrl,
                  icon: Icon(Icons.info),
                  iconSize: 30,
                ),
              ],
            ),
            Text(
                "(Confidence ${(disease.confidence * 100).toStringAsFixed(2)}%)",
                style: Theme.of(context).textTheme.bodyLarge),
            const Divider(height: 30, thickness: 2, color: Colors.green),
            SizedBox(
              height: size.height * 0.45,
              child: ListView(
                children: [
                  const SizedBox(height: 25),
                  Text(
                    "Possible cause",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    disease.possibleCauses,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Solution",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    disease.possibleSolution,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
