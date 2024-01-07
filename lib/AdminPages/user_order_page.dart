import 'package:agriplant/AdminPages/controller/admin_controller.dart';
import 'package:agriplant/models/order.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/models/user_model.dart';
import 'package:agriplant/utils/enum/order.dart';
import 'package:agriplant/AdminPages/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class UserOrdersPage extends StatelessWidget {
  const UserOrdersPage({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    Get.delete<AdminController>();
    final adminController = Get.put(AdminController());

    adminController.fetchAllOrder(user);

    final tabs = OrderStatus.values.map((e) => e.name).toList();
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("My orders"),
          bottom: TabBar(
              isScrollable: true,
              tabs: List.generate(tabs.length, (index) {
                return Tab(
                  text: tabs[index],
                );
              })),
        ),
        body: Obx(
          () {
            if(adminController.isOrderLoading.value) {
              return getproducteShimmerLoading();
            } else {
              return TabBarView(
            children: List.generate(
              tabs.length,
              (index) {
                final filteredOrders = adminController.allOrderList
                    .where((order) => order.status == OrderStatus.values[index])
                    .toList();
                return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return OrderItem(order: order, user: user);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: filteredOrders.length);
              },
            ),
          );
            }
          }
        ),
      ),
    );
  }


  Shimmer getproducteShimmerLoading() {
    final dummyProduct = Product.empty();
    final List<Product> dummyProductList = [dummyProduct, dummyProduct,];
    final dummyOrder = Order(id: 'id', products: dummyProductList, orderingDate: DateTime.now(), deliveringDate: DateTime.now(), status: OrderStatus.Processing);
    final List<Order> dummyOrderList = [dummyOrder, dummyOrder, dummyOrder, ];
    final tabs = OrderStatus.values.map((e) => e.name).toList();
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: TabBarView(
            children: List.generate(
              tabs.length,
              (index) {
                final filteredOrders = dummyOrderList
                    .where((order) => order.status == OrderStatus.values[index])
                    .toList();
                return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return OrderItem(order: order, user: user,);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: filteredOrders.length);
              },
            ),
          ),
      );
  }

}
