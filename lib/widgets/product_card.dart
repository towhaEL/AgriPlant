import 'package:agriplant/controllers/bookmarks_controller.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/pages/auth/global/common/toast.dart';
import 'package:agriplant/pages/product_details_page.dart';
import 'package:agriplant/repositories/cart_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isBookmark = false;
  bool onlyOnce = true;

  @override
  Widget build(BuildContext context) {
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
    
    return GestureDetector(
      onTap: (widget.product.productCode == -1)? null : () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              product: widget.product,
            ),
          ),
        );
      },
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(8),
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (widget.product.image!='')? CachedNetworkImageProvider(
                    widget.product.image,
                  ) : CachedNetworkImageProvider(
                    'https://firebasestorage.googleapis.com/v0/b/agriplant-1904047.appspot.com/o/Products%2FImages%2FThumbnails%2Fscaled_1000048600.jpg?alt=media&token=29ba5556-3a93-484f-837b-42368747600c',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: SizedBox(
                width: 30,
                height: 30,
                child: 
                IconButton.filledTonal(
                    padding: EdgeInsets.zero,
                    onPressed: () {
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
                    },
                    iconSize: 18,
                    icon: (isBookmark)? Icon(Icons.bookmark_added) : Icon(Icons.bookmark_add_outlined)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton.filled(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await cartRepository.addProductToCart(widget.product);
                            showToast(message: "Product added to cart.");
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
