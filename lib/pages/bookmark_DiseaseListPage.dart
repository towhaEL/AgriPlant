import 'package:agriplant/controllers/disease_controller.dart';
import 'package:agriplant/pages/diseases/disease_model.dart';
import 'package:agriplant/widgets/disease_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class DiseaseListPage extends StatelessWidget {
  const DiseaseListPage({super.key,});
  
  
  @override
  Widget build(BuildContext context) {
    Get.delete<DiseaseController>();
    final diseaseController = Get.put(DiseaseController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Saved identified diseases",
        ),
      ),
      body: Obx(
        () {
          if(diseaseController.isBookmarkLoading.value) {
            return getproducteShimmerLoading();
          } else {
            return ListView(padding: const EdgeInsets.all(16), children: [
          ...List.generate(diseaseController.bookmarkProducts.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: diseaseItem(bookmark_Item: diseaseController.bookmarkProducts[index],),
            );
          }),
        ]);
          }
        }
      ),
    );
  }

  Shimmer getproducteShimmerLoading() {
    final dummyProduct = Disease.empty();
    final List<Disease> dummyProductList = [dummyProduct,dummyProduct,];
    
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: ListView(padding: const EdgeInsets.all(16), children: [
          ...List.generate(dummyProductList.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: diseaseItem(bookmark_Item: dummyProductList[index],),
            );
          }),
        ]),
    );
  }
}
