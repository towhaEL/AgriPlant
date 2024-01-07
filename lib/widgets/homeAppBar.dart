import 'package:agriplant/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  // late final UserController controller;
  Widget build(BuildContext context) {
    Get.delete<UserController>();
    var controller = Get.put(UserController());
    // final controller = Get.lazyPut(()=>UserController());
    return Obx( 
              () {
                if(controller.profileLoading.value) {
                  return getShimmerLoading();
                } else {
                  return Text(
                controller.user.value.username,
                style: Theme.of(context).textTheme.titleMedium,
              );
                }
                
                
              }
            );
  }

  Shimmer getShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: Container(
        height: 18,
        width: 120,
        color: Colors.white,
      ),
      );
  }
}