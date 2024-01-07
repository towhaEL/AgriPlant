
import 'package:agriplant/models/product.dart';
import 'package:agriplant/repositories/cart_repository.dart';
import 'package:get/get.dart';

class CartController extends GetxController{
  static CartController get instance => Get.find();

  final isCartLoading = false.obs;
  RxList<Product> cartProducts = <Product>[].obs;
  final cartRepository = Get.put(CartRepository());
  final totalCost = ''.obs;

  @override
  void onInit() {
    fetchUserCart();
    super.onInit();
  }

  /// Fetch user cart record
  fetchUserCart() async {
    try {
      isCartLoading.value = true;

      final products = await cartRepository.fetchUserCart();
      cartProducts.assignAll(products);
      totalCost.value = (cartProducts.map((e) => e.price).reduce((acc, cur) => acc + cur)).toStringAsFixed(2);
      totalCost.refresh();
    } catch (e) {

    } finally {
      isCartLoading.value = false;
    }
  }


  // remove cart item
  Future<void> removeCartItem(Product cartItem) async {
    try {
      await cartRepository.removeCartItem(cartItem);
      fetchUserCart();
    } catch (e) {

    }
  }

  // remove single cart item
  Future<void> removeSingleCartItem(Product cartItem) async {
    try {
      await cartRepository.removeSingleCartItem(cartItem);
      fetchUserCart();
    } catch (e) {
    }
  }

  // add single cart item
  Future<void> addSingleCartItem(Product cartItem) async {
    try {
      cartRepository.addProductToCart(cartItem);
      fetchUserCart();
    } catch (e) {
    }
  }

  Future<void> removeWholeCart() async {
    try {
      cartRepository.removeWholeCart();
      fetchUserCart();
    } catch (e) {
    }
  }


}