import 'package:agriplant/controllers/processController.dart';
import 'package:agriplant/data/processes.dart';
import 'package:agriplant/models/process.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProcessDetailsPage extends StatefulWidget {
  const ProcessDetailsPage({super.key, required this.process});

  final Process process;

  @override
  State<ProcessDetailsPage> createState() => _ProcessDetailsPageState();
}

class _ProcessDetailsPageState extends State<ProcessDetailsPage> {
  late TapGestureRecognizer readMoreGestureRecognizer;
  bool showMore = false;
  bool isBookmark = false;
  bool onlyOnce = true;

  @override
  void initState() {
    super.initState();
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showMore = !showMore;
        });
      };
  }

  @override
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final processController = Get.put(ProcessController());

    if (onlyOnce) {
      for(var p in processController.bookmarkProducts) {
      if(p.processCode == widget.process.processCode) {
        isBookmark = true;
      }
    }
    onlyOnce = false;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Details",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child:
                IconButton(onPressed: () {
                  if(isBookmark) {
                    processController.removeFromBookmarks(widget.process);
                    // remove
                  } else {
                    processController.addToBookmarks(widget.process);
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 250,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  widget.process.image,
                ),
              ),
            ),
          ),
          Text(
            widget.process.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Description",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: showMore
                      ? widget.process.description
                      : "${widget.process.description.substring(0, widget.process.description.length - 100)}...",
                ),
                TextSpan(
                  recognizer: readMoreGestureRecognizer,
                  text: showMore ? " Read less" : " Read more",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "You can also read",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (widget.process.processCode != index) {}
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProcessDetailsPage(
                          process: processController.allProducts[index],
                        ),
                      ),
                    );
                  },
                  child: (widget.process.processCode != index)
                      // child: (widget.process != relatedprocesss[index])
                      ? Container(
                          height: 90,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(processes[index].image),
                            ),
                          ),
                        )
                      : Container(),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemCount: processController.allProducts.length,
              // itemCount: relatedprocesss.length,
            ),
          ),
        ],
      ),
    );
  }
}
