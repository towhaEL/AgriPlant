import 'package:agriplant/controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                  return Row(
                    children: [
                      SizedBox(width: 10,),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: 
                        CircleAvatar(
                          radius: 18,
                          foregroundImage: CachedNetworkImageProvider(controller.user.value.profilePicture),
                          ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hi there ${controller.user.value.fullname.split(' ')[0]}👋',
                              style: Theme.of(context).textTheme.titleMedium,),
                          Text("Enjoy our services",
                              style: Theme.of(context).textTheme.bodySmall,),
                        ],
                      ),
                    ],
                  );
                }
                
                
              }
            );
  }

  Shimmer getShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: Row(
                    children: [
                      SizedBox(width: 10,),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: 
                        CircleAvatar(
                          radius: 18,
                          foregroundImage: CachedNetworkImageProvider('https://firebasestorage.googleapis.com/v0/b/agriplant-1904047.appspot.com/o/Products%2FImages%2FThumbnails%2Fscaled_1000048863.jpg?alt=media&token=230dc0bd-088c-4a79-95ff-9897271338d0'),
                          ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 50, height: 10,),
                          Container(),
                        ],
                      ),
                    ],
                  ),
      );
  }
}