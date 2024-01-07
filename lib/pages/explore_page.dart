import 'package:agriplant/controllers/product_controller.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/pages/search_page.dart';
import 'package:agriplant/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_search/overlay_search.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});
  
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  final OverlaySearchController overlayController = OverlaySearchController();


  Widget build(BuildContext context) {

    Get.delete<ProductController>();
    final productController = Get.put(ProductController());

    // Get.delete<CartController>();
    // final productController = Get.put(ProductController());

    openDialPad(String phoneNumber) async {
      Uri url = Uri(scheme: "tel", path: phoneNumber);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print("Can't open dial pad.");
      }
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 15.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           // controller: _searchController,
          //           decoration: InputDecoration(
          //             hintText: "Search here...",
          //             isDense: true,
          //             contentPadding: const EdgeInsets.all(12),
          //             border: OutlineInputBorder(
          //               borderSide: BorderSide(
          //                 color: Colors.grey.shade300,
          //               ),
          //               borderRadius: const BorderRadius.all(
          //                 Radius.circular(99),
          //               ),
          //             ),
          //             prefixIcon: const Icon(IconlyLight.search),
          //           ),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 12.0),
          //         child: IconButton.filled(
          //           onPressed: () {},
          //           icon: const Icon(
          //             IconlyLight.filter,
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // search

          HomeSearch(overlayController: overlayController,),
          SizedBox(height: 10,),

          
          // processItem(process: processes[0]),
          // processItem(process: processes[2]),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: SizedBox(
              height: 170,
              child: Card(
                color: Colors.green.shade50,
                elevation: 0.1,
                shadowColor: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Free Consultation",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.green.shade700),
                            ),
                            const Text(
                                "Get free support from our customer service"),
                            FilledButton(
                                onPressed: () {
                                  openDialPad("01537625255");
                                },
                                child: const Text("Call now"))
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/contact_us.png',
                        width: 140,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Featured products",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {},
                child: const Text("See all products"),
              ),
            ],
          ),
          Obx(
            () {
              if(productController.isLoading.value) {
                return getproducteShimmerLoading();
              } else {
                return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productController.allProducts
                    .where((product) => product.isFeatured == true)
                    .toList().length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  product: productController.allProducts
                    .where((product) => product.isFeatured == true)
                    .toList()[index],
                );
              },
            );
              }
            }
          )
        ],
      ),
    );
  }

  Shimmer getproducteShimmerLoading() {
    final dummyProduct = Product.empty();
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  product: dummyProduct,
                );
              },
            )  
      );
  }
  


}
