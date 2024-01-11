
import 'package:agriplant/pages/diseases/disease_model.dart';
import 'package:agriplant/repositories/disease_repository.dart';
import 'package:get/get.dart';

class DiseaseController extends GetxController{
  static DiseaseController get instance => Get.find();

  final isBookmarkLoading = false.obs;
  RxList<Disease> bookmarkProducts = <Disease>[].obs;
  final diseaseRepository = Get.put(DiseaseRepository());

  @override
  void onInit() {
    fetchUserBookmark();
    super.onInit();
  }

  /// Fetch user Bookmark record
  fetchUserBookmark() async {
    try {
      isBookmarkLoading.value = true;
      final products = await diseaseRepository.fetchUserBookmark();
      bookmarkProducts.assignAll(products);
    } catch (e) {

    } finally {
      isBookmarkLoading.value = false;
    }
  }

  // remove single Bookmark item
  Future<void> removeFromBookmarks(Disease bookmarkItem) async {
    try {
      await diseaseRepository.removeSingleBookmarkItem(bookmarkItem);
      fetchUserBookmark();
    } catch (e) {
    }
  }

  // add single Bookmark item
  Future<void> addToBookmarks(Disease bookmarkItem) async {
    try {
      // print(bookmarkItem.diseaseCode);
      diseaseRepository.addProductToBookmark(bookmarkItem);
      fetchUserBookmark();
    } catch (e) {
    }
  }


}