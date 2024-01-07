import 'dart:async';

import 'package:agriplant/controllers/cart_controller.dart';
import 'package:agriplant/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key, required this.cartItems, required this.cartItem}); //, required this.productQty
  final Product cartItem;
  final List<Product> cartItems;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int productQty = 5;
  bool productQtyAssigned = false;
  @override
  Widget build(BuildContext context) {
    Get.delete<CartController>();
    final cartController = Get.put(CartController());

    if(!productQtyAssigned) {
      productQty = widget.cartItems.where((e) => e.productCode == widget.cartItem.productCode).length;
      productQtyAssigned = true;
    }

    
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(IconlyLight.delete),
      ),
      confirmDismiss: (direction) async {
        final completer = Completer<bool>();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: const Text("Remove from cart?"),
            action: SnackBarAction(
                label: "Keep",
                onPressed: () {
                  completer.complete(false);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }),
          ),
        );

        Timer(const Duration(seconds: 2), () {
          if (!completer.isCompleted) {
            completer.complete(true);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            cartController.removeCartItem(widget.cartItem);
          }
        });
        return await completer.future;
      },
      child: SizedBox(
        height: 125,
        child: Card(
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
            child: Row(
              children: [
                Container(
                  width: 95,
                  height: double.infinity,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: (widget.cartItem.image!='')? CachedNetworkImageProvider(widget.cartItem.image) :
                      CachedNetworkImageProvider('https://firebasestorage.googleapis.com/v0/b/agriplant-1904047.appspot.com/o/Products%2FImages%2FThumbnails%2Fscaled_1000048600.jpg?alt=media&token=29ba5556-3a93-484f-837b-42368747600c'),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        widget.cartItem.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        widget.cartItem.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${widget.cartItem.price}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          SizedBox(
                            height: 30,
                            child: ToggleButtons(
                              onPressed: (index) {
                                if (index == 0) {
                                  cartController.removeSingleCartItem(widget.cartItem);
                                  setState(() {
                                    productQty -= 1;
                                  });
                                  
                                  //decrease quantity
                                } else if (index == 2) {
                                  cartController.addSingleCartItem(widget.cartItem);
                                  setState(() {
                                    productQty += 1;
                                  });
                                  
                                  //increase quantity
                                }
                              },
                              borderRadius: BorderRadius.circular(20),
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              constraints: const BoxConstraints(
                                  minHeight: 30, minWidth: 30),
                              isSelected: const [true, false, true],
                              children: [
                                Icon(Icons.remove),
                                Text('${productQty}'),
                                Icon(Icons.add)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
