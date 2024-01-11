
import 'package:agriplant/models/process.dart';
import 'package:agriplant/repositories/processRepository.dart';
import 'package:get/get.dart';

class ProcessController extends GetxController{
  static ProcessController get instance => Get.find();

  final isLoading = false.obs;
  final _processRepository = Get.put(ProcessRepository());
  RxList<Process> allProducts = <Process>[].obs;
  final isBookmarkLoading = false.obs;
  RxList<Process> bookmarkProducts = <Process>[].obs;

  @override
  void onInit() {
    fetchProducts();
    fetchUserBookmark();
    super.onInit();
  }

  // Load service data
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final products = await _processRepository.getAllProducts();

      allProducts.assignAll(products);
    } catch (e) {
      
    } finally {
      isLoading.value = false;

    }
  }


  Future<void> addNewProduct(Process product) async {
    try {
      await fetchProducts();
      int id = allProducts.length;
      product.processCode = id;
      
      
      _processRepository.addNewProduct(product, id.toString());

    } catch (e) {

    }
  }

  /// Fetch user Bookmark record
  fetchUserBookmark() async {
    try {
      isBookmarkLoading.value = true;
      final products = await _processRepository.fetchUserBookmark();
      bookmarkProducts.assignAll(products);
    } catch (e) {

    } finally {
      isBookmarkLoading.value = false;
    }
  }

  // remove single Bookmark item
  Future<void> removeFromBookmarks(Process bookmarkItem) async {
    try {
      await _processRepository.removeSingleBookmarkItem(bookmarkItem);
      fetchUserBookmark();
    } catch (e) {
    }
  }

  // add single Bookmark item
  Future<void> addToBookmarks(Process bookmarkItem) async {
    try {
      // print(bookmarkItem.ProcessCode);
      _processRepository.addProductToBookmark(bookmarkItem);
      fetchUserBookmark();
    } catch (e) {
    }
  }




}