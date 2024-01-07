import 'package:agriplant/controllers/bookmarks_controller.dart';
import 'package:agriplant/widgets/bookmark_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookmarkListPage extends StatelessWidget {
  const BookmarkListPage({super.key, required this.pageInfo});
  final String pageInfo;
  
  @override
  Widget build(BuildContext context) {
    late final bookmarkList;
    Get.delete<BookmarkController>();
    var bookmarkController = Get.put(BookmarkController());
    if (pageInfo == 'product'){
      bookmarkList = bookmarkController.bookmarkProducts;
    }
    


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Saved ${pageInfo}",
        ),
      ),
      body: Obx(
        () => ListView(padding: const EdgeInsets.all(16), children: [
          ...List.generate(bookmarkList.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: bookmarkItem(bookmark_Item: bookmarkList[index]),
            );
          }),
        ]),
      ),
    );
  }
}
