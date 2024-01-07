import 'package:agriplant/AdminPages/add_products.dart';
import 'package:agriplant/AdminPages/order_management.dart';
import 'package:agriplant/controllers/user_controller.dart';
import 'package:agriplant/pages/auth/global/common/toast.dart';
import 'package:agriplant/pages/orders_page.dart';
import 'package:agriplant/pages/profileInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<UserController>();
    var controller = Get.put(UserController());
    return Scaffold(
      body: ListView(
        children: [
          Obx( 
              () {
                if(controller.profileLoading.value) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
                    child: CircleAvatar(
                      radius: 62,
                      backgroundColor: Theme.of(context).colorScheme.primary,child: getShimmerLoading()),
                  );
                } else {
                return  Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
                  child: CircleAvatar(
                  radius: 62,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: 
                  CircleAvatar(
                    radius: 60,
                    foregroundImage: CachedNetworkImageProvider(controller.user.value.profilePicture),
                    ),
                  ),    
                );
                }
               }
            ),
          Center(
            child: Obx(
              () => Text(
                controller.user.value.username,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Center(
            child:  Obx(
              () => Text(
                controller.user.value.email,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ),
          
          const SizedBox(height: 25),
          ListTile(
            title: const Text("Information"),
            leading: const Icon(IconlyLight.infoSquare),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("My orders"),
            leading: const Icon(IconlyLight.buy),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrdersPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("About us & privacy"),
            leading: const Icon(IconlyLight.infoSquare),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(IconlyLight.logout),
            onTap: () {
              FirebaseAuth.instance.signOut();
              GoogleSignIn().signOut();
              Navigator.pushReplacementNamed(context, "/login");
              showToast(message: "Successfully signed out");
            },
          ),
          const Padding(
            padding: const EdgeInsets.all(30.0),
            child: Divider(
              color: Color(0xFFD9D9D9),
              height: 10,
            ),
          ),
          Obx(
            () { 
            if(controller.user.value.isAdmin){
            return Column(
              children: [
                ListTile(
                  title: const Text("Add products"),
                  leading: const Icon(IconlyLight.plus),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => addProducts(),
                      ),
                    );
                  },
                ),
                ListTile(
              title: const Text("Order Management"),
              leading: const Icon(IconlyLight.document),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => orderManagement(),
                  ),
                );
              },
            )
              ],
            );
            } else {
              return Container();
            }
          }),
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 15),
          //   child: ListTile(
          //     title: const Text("Delete account", style: TextStyle(color: Colors.red),),
          //     leading: const Icon(IconlyLight.delete, color: Colors.red,),
          //     onTap: () {
                
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }


  Shimmer getShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: CircleAvatar(
        radius: 60,
      )
      );
  }


}
