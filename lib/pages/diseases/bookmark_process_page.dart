import 'package:agriplant/controllers/processController.dart';
import 'package:agriplant/models/process.dart';
import 'package:agriplant/widgets/cultivation_process.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProcessListPage extends StatelessWidget {
  const ProcessListPage({super.key,});
  
  
  @override
  Widget build(BuildContext context) {
    Get.delete<ProcessController>();
    final processController = Get.put(ProcessController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Saved Cultivation Processes",
        ),
      ),
      body: Obx(
        () {
          if(processController.isBookmarkLoading.value) {
            return getproducteShimmerLoading();
          } else {
            return ListView(padding: const EdgeInsets.all(16), children: [
          ...List.generate(processController.bookmarkProducts.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: processItem(process: processController.allProducts[index]),
            );
          }),
        ]);
          }
        }
      ),
    );
  }

  Shimmer getproducteShimmerLoading() {
    final dummyProduct = Process.empty();
    final List<Process> dummyProductList = [dummyProduct,dummyProduct,];
    
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: ListView(padding: const EdgeInsets.all(16), children: [
          ...List.generate(dummyProductList.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: processItem(process: dummyProductList[index],),
            );
          }),
        ]),
    );
  }
}
