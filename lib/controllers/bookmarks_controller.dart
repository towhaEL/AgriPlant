
import 'package:agriplant/models/product.dart';
import 'package:agriplant/repositories/bookmarks_repository.dart';
import 'package:get/get.dart';

class BookmarkController extends GetxController{
  static BookmarkController get instance => Get.find();

  final isBookmarkLoading = false.obs;
  RxList<Product> bookmarkProducts = <Product>[].obs;
  final bookmarkRepository = Get.put(BookmarkRepository());

  @override
  void onInit() {
    fetchUserBookmark();
    super.onInit();
  }

  /// Fetch user Bookmark record
  fetchUserBookmark() async {
    try {
      isBookmarkLoading.value = true;

      final products = await bookmarkRepository.fetchUserBookmark();
      bookmarkProducts.assignAll(products);
    } catch (e) {

    } finally {
      isBookmarkLoading.value = false;
    }
  }

  // remove single Bookmark item
  Future<void> removeFromBookmarks(Product bookmarkItem) async {
    try {
      await bookmarkRepository.removeSingleBookmarkItem(bookmarkItem);
      fetchUserBookmark();
    } catch (e) {
    }
  }

  // add single Bookmark item
  Future<void> addToBookmarks(Product bookmarkItem) async {
    try {
      bookmarkRepository.addProductToBookmark(bookmarkItem);
      fetchUserBookmark();
    } catch (e) {
    }
  }


}