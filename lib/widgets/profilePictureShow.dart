
// import 'package:agriplant/controllers/user_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';

// class showProfilePicture extends StatelessWidget {
//   const showProfilePicture({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.delete<UserController>();
//     var controller = Get.put(UserController());

//     return Obx( 
//               () {
//                 if(controller.imageUploading.value) {
//                   return CircleAvatar(
//                     radius: 62,
//                     backgroundColor: Theme.of(context).colorScheme.primary,child: getShimmerLoading());
//                 } else {
//                 return  Padding(
//                   padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
//                   child: CircleAvatar(
//                   radius: 62,
//                   backgroundColor: Theme.of(context).colorScheme.primary,
//                   child:  CircleAvatar(
//                     radius: 60,
//                     foregroundImage: NetworkImage("${controller.user.value.profilePicture}"),
//                     ),
//                   ),    
//                 );
//                 }
//                }
//             );
    
//   }


//   Shimmer getShimmerLoading() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
//       child: CircleAvatar(
//         radius: 60,
//       )
//       );
//   }


// }