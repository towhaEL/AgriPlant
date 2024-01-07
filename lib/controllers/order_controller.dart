
import 'package:agriplant/models/order.dart';
import 'package:agriplant/models/order_model.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/pages/auth/global/common/toast.dart';
import 'package:agriplant/repositories/order_repository.dart';
import 'package:get/get.dart';

class OrderController extends GetxController{
  static OrderController get instance => Get.find();

  final isOrderLoading = false.obs;
  RxList<Order> allOrderList = <Order>[].obs;
  final orderRepository = Get.put(OrderRepository());

  @override
  void onInit() {
    fetchAllOrder();
    super.onInit();
  }

  /// Fetch all order
  fetchAllOrder() async {
    try {
      isOrderLoading.value = true;
      final orderList = await orderRepository.fetchAllOrder();
      allOrderList.assignAll(orderList);
      // print('order fetched');

    } catch (e) {

    } finally {
      isOrderLoading.value = false;
    }
  }




  Future<void> proceedToOrder(List<Product> cartItems) async {
    final orderList = await orderRepository.getOrderId();
    final orderId = orderList.length;
    try {
      final order = OrderModel(orderId: orderId, orderingDate: DateTime.now().toString(), deliveringDate: DateTime.now().add(const Duration(days: 3)).toString(), status: 'Processing');
      orderRepository.cartToOrder(order, cartItems, orderId);
      showToast(message: "Order placed");
    } catch (e) {
    }
  }


}