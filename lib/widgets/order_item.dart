import 'dart:ui';

import 'package:agriplant/models/order.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/widgets/order_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.order, this.visibleProduct = 2, this.isClickable = true});
  final Order order;
  final visibleProduct;
  final bool isClickable;

  @override
  Widget build(BuildContext context) {
    final distinctProduct = getUniqueProducts(order.products);
    // final products = order.products.take(2).toList();
    final products = distinctProduct.take(visibleProduct).toList();
    final totalPrice = order.products.fold(0.0, (acc, e) => acc + e.price);
    return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          side: BorderSide(
            width: 0.2,
            color: Colors.grey.shade400,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    ("Order: ${order.id}#${order.orderingDate.hashCode}"),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    "(${order.products.length} Items)",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 5),
                  Text("\$${totalPrice.toStringAsFixed(2)}")
                ],
              ),
              const SizedBox(height: 20),
              ...List.generate(products.length, (index) {
                return OrderProduct(order: order, product: products[index], isClickable: isClickable);
              }),
              if (distinctProduct.length > 2 || isClickable == false)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          barrierColor: Colors.white.withOpacity(.7),
                          isScrollControlled: true,
                          builder: (context) {
                            return ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5,
                                  sigmaY: 5,
                                ),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .5,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: distinctProduct.length,
                                      itemBuilder: (context, index) {
                                        return OrderProduct(
                                            order: order,
                                            product: distinctProduct[index]);
                                      }),
                                ),
                              ),
                            );
                          });
                    },
                    label: const Text("View all"),
                    icon: const Icon(IconlyLight.arrowRight3),
                  ),
                )
            ],
          ),
        ));
  }


  List<Product> getUniqueProducts(List<Product> products) {
  // Use a Set to automatically eliminate duplicates based on product ID
  Set<String> uniqueProductIds = Set<String>();

  // List to store unique products
  List<Product> uniqueProducts = [];

  for (Product product in products) {
    // Check if the product ID is not in the set (not encountered before)
    if (uniqueProductIds.add(product.productCode.toString())) {
      uniqueProducts.add(product);
    }
  }
  return uniqueProducts;
  }
}
