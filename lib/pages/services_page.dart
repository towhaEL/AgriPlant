import 'dart:ui';

import 'package:agriplant/controllers/service_controller.dart';
import 'package:agriplant/pages/crop_diseases_page.dart';
import 'package:agriplant/pages/cultivation_process_page.dart';
import 'package:agriplant/pages/service_products.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.delete<ServiceController>();
    final serviceController = Get.put(ServiceController());

    return Scaffold(
      body: Obx(() {
        if(serviceController.isLoading.value) {
          return getServiceShimmerLoading();
        } else {
           return GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: serviceController.allServices.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          // final service = services[index];
          return GestureDetector(
            onTap: () {
              if (index == 4) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => cultivationProcess()),
                );
              } else if (index == 5) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => cropDisease()),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          serviceProducts(service: serviceController.allServices[index])),
                );
              }
            },
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: 
                DecorationImage(
                  fit: BoxFit.cover,
                  image: 
                  CachedNetworkImageProvider(
                    serviceController.allServices[index].imageUrl,
                  ),
                ),
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade500.withOpacity(.1),
                    ),
                    child: Text(
                      serviceController.allServices[index].name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

        }
        
      })
    );
  }



  Shimmer getServiceShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return 
        
             Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),  
              color: Colors.white,
              ),
              
            );
          
        },
      ),
      );
  }


}
