import 'package:agriplant/data/processes.dart';
import 'package:agriplant/widgets/cultivation_process.dart';
import 'package:flutter/material.dart';

class cultivationProcess extends StatelessWidget {
  const cultivationProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Cultivation process",
        ),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ...List.generate(processes.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: processItem(process: processes[index]),
          );
        }),
      ]),
    );
  }
}
