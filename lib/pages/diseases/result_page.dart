import 'dart:io';

import 'package:agriplant/controllers/disease_controller.dart';
import 'package:agriplant/pages/diseases/disease_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class showResult extends StatefulWidget {
  const showResult({super.key, required this.disease, this.imagePath = "null"});
  final Disease disease;
  final String imagePath;

  @override
  State<showResult> createState() => _showResultState();
}

class _showResultState extends State<showResult> {
  bool isBookmark = false;
  bool onlyOnce = true;

  @override
  Widget build(BuildContext context) {
    final diseaseController = Get.put(DiseaseController());
    if (onlyOnce) {
      for(var p in diseaseController.bookmarkProducts) {
      if(p.diseaseCode == widget.disease.diseaseCode) {
        isBookmark = true;
      }
    }
    onlyOnce = false;
    }

    List<String> strarray = widget.disease.name.split(" ");
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

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
                  if(isBookmark) {
                    diseaseController.removeFromBookmarks(widget.disease);
                    // remove
                  } else {
                    diseaseController.addToBookmarks(widget.disease);
                    //add
                  }
                  setState(() {
                    isBookmark = !isBookmark;
                  });
                }, icon: (isBookmark)? Icon(Icons.bookmark_added) : Icon(Icons.bookmark_add_outlined)
              ),
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
                  backgroundImage: (widget.imagePath == 'null')? CachedNetworkImageProvider(widget.disease.imagePath) : 
                    Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.cover,
                  ).image,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.disease.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,

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
                "( Confidence ${(double.parse(widget.disease.confidence) * 100).toStringAsFixed(2)}% )",
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
                    widget.disease.possibleCauses,
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
                    widget.disease.possibleSolution,
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
