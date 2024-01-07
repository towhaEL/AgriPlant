import 'package:agriplant/AdminPages/controller/admin_controller.dart';
import 'package:agriplant/AdminPages/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class orderManagement extends StatefulWidget {
  const orderManagement({super.key});

  @override
  State<orderManagement> createState() => _orderManagementState();
}

class _orderManagementState extends State<orderManagement> {
  @override
  Widget build(BuildContext context) {
    Get.delete<AdminController>();
    var adminController = Get.put(AdminController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "User list",
        ),
      ),
      body: Obx(
        () => ListView(padding: const EdgeInsets.all(16), children: [
          ...List.generate(adminController.userList.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: userCard(user: adminController.userList[index]),
            );
          }),
        ]),
      ),
    );
  }
}