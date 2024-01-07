import 'dart:math';

import 'package:agriplant/controllers/bookmarks_controller.dart';
import 'package:agriplant/controllers/product_controller.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/pages/auth/global/common/toast.dart';
import 'package:agriplant/repositories/cart_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late TapGestureRecognizer readMoreGestureRecognizer;
  bool showMore = false;
  int productCount=1;
  bool isBookmark = false;
  bool onlyOnce = true;

  @override
  void initState() {
    super.initState();
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showMore = !showMore;
        });
      };
  }

  @override
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get.delete<BookmarkController>();
    final productController = Get.put(ProductController());
    final cartRepository = Get.put(CartRepository());
    final bookmarkController = Get.put(BookmarkController());

    if (onlyOnce) {
      for(var p in bookmarkController.bookmarkProducts) {
      if(p.productCode == widget.product.productCode) {
        isBookmark = true;
      }
    }
    onlyOnce = false;
    }
    
    // final relatedProducts = productController.allProducts
    //     .where((p) => p.serviceCode == widget.product.serviceCode)
    //     .toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Details",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child:
                IconButton(onPressed: () {
                  if(isBookmark) {
                    bookmarkController.removeFromBookmarks(widget.product);
                    // remove
                  } else {
                    bookmarkController.addToBookmarks(widget.product);
                    //add
                  }
                  setState(() {
                    isBookmark = !isBookmark;
                  });
                }, icon: (isBookmark)? Icon(Icons.bookmark_added) : Icon(Icons.bookmark_add_outlined)
                ),
          )
        ],
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    widget.product.image,
                  ),
                ),
              ),
            ),
            Text(
              widget.product.name,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.product.stock != 0)
                    ? Text(
                        "Available in stock",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    : Text(
                        "Stock out",
                        style: TextStyle(
                          color: Colors.red.shade700,
                        ),
                      ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "\$${widget.product.price}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text: "/${widget.product.unit}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow.shade800,
                ),
                Text(
                  "${widget.product.rating} (192)",
                ),
                const Spacer(),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: IconButton.filled(
                    padding: EdgeInsets.zero,
                    onPressed: (productCount>0)? () {
                        setState(() {
                          productCount -= 1;
                        });
                    } : null,
                    icon: const Icon(Icons.remove),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    "${productCount} ${widget.product.unit}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: IconButton.filled(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        productCount += 1;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Description",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 5,
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: showMore
                        ? widget.product.description
                        : "${widget.product.description.substring(0, min((widget.product.description.length/2).ceil(), 200))}...",
                  ),
                  TextSpan(
                    recognizer: readMoreGestureRecognizer,
                    text: showMore ? " Read less" : " Read more",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Related products",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 90,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (widget.product.productCode != index) {}
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            product: productController.allProducts
          .where((p) => p.serviceCode == widget.product.serviceCode)
          .toList()[index],
                          ),
                        ),
                      );
                    },
                    // child: (widget.product.productCode != index)
                    child: (widget.product.productCode != productController.allProducts
          .where((p) => p.serviceCode == widget.product.serviceCode)
          .toList()[index].productCode)
                        ? Container(
                            height: 90,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(productController.allProducts
          .where((p) => p.serviceCode == widget.product.serviceCode)
          .toList()[index].image),
                              ),
                            ),
                          )
                        : Container(),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                // itemCount: products.length,
                itemCount: productController.allProducts
          .where((p) => p.serviceCode == widget.product.serviceCode)
          .toList().length,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FilledButton.icon(
                onPressed: () {
                  for (var i = 0; i < productCount; i++) {
                    cartRepository.addProductToCart(widget.product);
                  }
                  showToast(message: "Product added to cart.");
                },
                icon: const Icon(IconlyLight.bag),
                label: const Text("Add to cart"))
          ],
        ),
      ),
    );
  }
}
