
import 'package:agriplant/AdminPages/repository/admin_repository.dart';
import 'package:agriplant/models/order.dart';
import 'package:agriplant/models/user_model.dart';
import 'package:get/get.dart';

class AdminController extends GetxController{
  static AdminController get instance => Get.find();


  RxBool userLoading = false.obs;
  RxList<UserModel> userList = <UserModel>[].obs;
  final adminRepository = Get.put(AdminRepository());

  final isOrderLoading = false.obs;
  RxList<Order> allOrderList = <Order>[].obs;

    @override
  void onInit() {
    super.onInit();
    getAllUsers();
  }


    // Load user data
  Future<void> getAllUsers() async {
    try {
      userLoading.value = true;

      final users = await adminRepository.getAllUsers();

      userList.assignAll(users);
      print(userList[0].uid);
    } catch (e) {
      
    } finally {
      userLoading.value = false;

    }
  }

  /// Fetch user order
  fetchAllOrder(UserModel user) async {
    try {
      isOrderLoading.value = true;
      final orderList = await adminRepository.fetchAllOrder(user);
      allOrderList.assignAll(orderList);
      // print('order fetched');

    } catch (e) {

    } finally {
      isOrderLoading.value = false;
    }
  }

  /// update user order
  updateSingleField(UserModel user, String orderId, Map<String, dynamic> json) async {
    try {
      await adminRepository.updateSingleField(user, orderId, json);
      // print('order fetched');

    } catch (e) {

    } finally {
      isOrderLoading.value = false;
    }
  }
}