
import 'package:agriplant/models/product.dart';
import 'package:agriplant/repositories/product_repository.dart';
import 'package:get/get.dart';

class ProductController extends GetxController{
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final _productRepository = Get.put(ProductRepository());
  RxList<Product> allProducts = <Product>[].obs;
  RxInt size = 0.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  // Load service data
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final products = await _productRepository.getAllProducts();

      allProducts.assignAll(products);
      size.value = allProducts.length;
    } catch (e) {
      
    } finally {
      isLoading.value = false;

    }
  }


  Future<void> addNewProduct(Product product) async {
    try {
      // print('object');
      await fetchProducts();
      // print('object2');
      int id = allProducts.length;
      print(id);
      product.productCode = id;
      print(product.productCode);
      final productRepository = Get.put(ProductRepository());
      
      productRepository.addNewProduct(product, id.toString());

    } catch (e) {

    }
  }


}