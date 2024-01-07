import 'package:agriplant/models/process.dart';
import 'package:agriplant/pages/cultivation_process_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class processItem extends StatelessWidget {
  const processItem({super.key, required this.process});

  final Process process;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          side: BorderSide(
            width: 0.2,
            color: Colors.grey.shade400,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 95,
                height: double.infinity,
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(process.image),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      process.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      process.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    // const Spacer(),
                    SizedBox(
                        height: 40,
                        child: TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProcessDetailsPage(
                                    process: process,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(IconlyLight.arrowRight),
                            label: const Text("Read details")))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
