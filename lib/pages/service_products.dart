import 'package:agriplant/controllers/product_controller.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/models/service.dart';
import 'package:agriplant/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class serviceProducts extends StatelessWidget {
  serviceProducts({super.key, required this.service});
  final Service service;

  @override
  Widget build(BuildContext context) {
    Get.delete<ProductController>();
    final productController = Get.put(ProductController());

    // final serviceBasedProducts = productController.allProducts
    //     .where((product) => product.serviceCode == service.serviceCode)
    //     .toList().length;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          service.name,
        ),
      ),
      body: Obx(
        () {
          if(productController.isLoading.value) {
            return getproducteShimmerLoading();
          } else {
            return ListView(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productController.allProducts
        .where((product) => product.serviceCode == service.serviceCode)
        .toList().length,
              // itemCount: serviceBasedProduct[serviceIndex].length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  product: productController.allProducts
        .where((product) => product.serviceCode == service.serviceCode)
        .toList()[index],
                );
              },
            ),
          ],
        );
          }
        }
      ),
    );
  }



  Shimmer getproducteShimmerLoading() {
    final dummyProduct = Product.empty();
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: ListView(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  product: dummyProduct,
                );
              },
            ),
          ],
        ),
      );
  }



}
