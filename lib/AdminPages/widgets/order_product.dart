import 'dart:ui';

import 'package:agriplant/models/order.dart';
import 'package:agriplant/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OrderProduct extends StatefulWidget {
  const OrderProduct({super.key, required this.order, required this.product, this.isClickable = true});
  final Order order;
  final Product product;
  final bool isClickable;

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  @override
  Widget build(BuildContext context) {    
    final distinctProduct = getUniqueProducts(widget.order.products);
    final productQty = widget.order.products.where((e) => e.productCode == widget.product.productCode).length;
    return GestureDetector(
      onTap: () {
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
                                                    order: widget.order,
                                                    product: distinctProduct[index]);
                                              }),
                                        ),
                                      ),
                                    );
                                  });
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            height: 90,
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: (widget.product.image!='')? CachedNetworkImageProvider(
                    widget.product.image,
                  ) : CachedNetworkImageProvider(
                    'https://firebasestorage.googleapis.com/v0/b/agriplant-1904047.appspot.com/o/Products%2FImages%2FThumbnails%2Fscaled_1000048600.jpg?alt=media&token=29ba5556-3a93-484f-837b-42368747600c',
                  ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  widget.product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${widget.product.price}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Qty: $productQty",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
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
