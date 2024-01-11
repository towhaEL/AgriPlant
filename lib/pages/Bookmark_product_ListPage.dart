import 'package:agriplant/controllers/bookmarks_controller.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/widgets/bookmark_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class BookmarkListPage extends StatelessWidget {
  const BookmarkListPage({super.key,});
  
  
  @override
  Widget build(BuildContext context) {
    Get.delete<BookmarkController>();
    final bookmarkController = Get.put(BookmarkController());


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Saved products",
        ),
      ),
      body: Obx(
        () {
          if(bookmarkController.isBookmarkLoading.value) {
            return getproducteShimmerLoading();
          } else {
            return ListView(padding: const EdgeInsets.all(16), children: [
          ...List.generate(bookmarkController.bookmarkProducts.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: bookmarkItem(bookmark_Item: bookmarkController.bookmarkProducts[index]),
            );
          }),
        ]);
          }
        }
      ),
    );
  }

  Shimmer getproducteShimmerLoading() {
    final dummyProduct = Product.empty();
    final List<Product> dummyProductList = [dummyProduct,dummyProduct,];
    
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: ListView(padding: const EdgeInsets.all(16), children: [
          ...List.generate(dummyProductList.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: bookmarkItem(bookmark_Item: dummyProductList[index],),
            );
          }),
        ]),
    );
  }
}
