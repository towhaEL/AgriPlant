import 'dart:ui';

import 'package:agriplant/controllers/user_controller.dart';
import 'package:agriplant/widgets/form_container_widget.dart';
import 'package:agriplant/controllers/cart_controller.dart';
import 'package:agriplant/controllers/order_controller.dart';

import 'package:agriplant/models/product.dart';
import 'package:agriplant/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _postCodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool onlyOnce = true;
  bool isCartEmpty = false;

  @override
  Widget build(BuildContext context) {
    Get.delete<CartController>();
    Get.delete<UserController>();
    Get.delete<OrderController>();
    final userController = Get.put(UserController());
    final cartController = Get.put(CartController());
    final orderController = Get.put(OrderController());
    
    if (onlyOnce) {
      isCartEmpty = false;
      onlyOnce = false;
    }

    return Scaffold(
        body: Obx(
          () {
            if (cartController.isCartLoading.value) {
              return getproducteShimmerLoading();
            } else if (cartController.cartProducts.isEmpty || isCartEmpty) {
              return Container(
                padding: EdgeInsets.only(left: 50, right: 50,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/emptyCartLogo.png'),
                  fit: BoxFit.cover,
                ),
              ),
                    ),
                    Text("Your cart is empty",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10,),
                    Text("Looks like you have not added anything to your cart. Go ahead & explore top services",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    // fontWeight: FontWeight.bold,
                    // fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                    ),
                  ],
                )
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(
                    const Duration(seconds: 1),
                  );
                  setState(() {
                    
                  });
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                          ...List.generate(getUniqueProducts(cartController.cartProducts).length, (index) {
                            return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: GestureDetector(
                  onTap: (){
                    // product page
                  },
                  child: CartItem(cartItems: cartController.cartProducts, cartItem: getUniqueProducts(cartController.cartProducts)[index])),
                            );
                          }),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                Text("Total (${getUniqueProducts(cartController.cartProducts).length})"),
                Obx(
                  () => Text(
                    "\$${cartController.totalCost.value}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                onPressed: () async {
                  _nameController.text = userController.user.value.fullname;
                  _phoneController.text = userController.user.value.phoneNumber;
                  _addressController.text = userController.user.value.address;
                  _cityController.text = userController.user.value.city;
                  _postCodeController.text = userController.user.value.postCode;
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
                                      MediaQuery.of(context).size.height * .6,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                                    child: Column(
                                      children: [
                                        FormContainerWidget(
                                          controller: _nameController,
                                          hintText: "Your name",
                                        ),
                                        SizedBox(height: 20,),
                                        FormContainerWidget(
                                          controller: _phoneController,
                                          hintText: "Phone No.",
                                          inputType: TextInputType.number,
                                        ),
                                        SizedBox(height: 20,),
                                        FormContainerWidget(
                                          controller: _addressController,
                                          hintText: "Address",
                                          inputType: TextInputType.streetAddress,
                                        ),
                                        SizedBox(height: 20,),
                                        SizedBox(
                                          // width: MediaQuery.of(context).size.width * .2,
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width * .9,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * .4,
                                                child: FormContainerWidget(
                                                controller: _cityController,
                                                hintText: "City",
      
                                                ),
                                              ),
                                            SizedBox(width: 10,),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * .4,
                                                child: FormContainerWidget(
                                                controller: _postCodeController,
                                                hintText: "Post Code",
                                                inputType: TextInputType.number,
                                                ),
                                              ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 100,),
                                        FilledButton.tonalIcon(
                            
                                          onPressed: () async {
                                            String FullName = _nameController.text;
                                            String phoneNo = _phoneController.text;
                                            String address = _addressController.text;
                                            String city = _cityController.text;
                                            String postCode = _postCodeController.text;

                                            Map<String, dynamic> updated_user = {'fullname': FullName, 'phoneNumber': phoneNo, 'address': address, 'city': city, 'postCode': postCode };
                                            userController.updateSingleField(updated_user);
                                            
                                            await orderController.proceedToOrder(cartController.cartProducts);
                                            Navigator. of(context). pop();
                                            setState(() {
                                              isCartEmpty = true;
                                            });                              
                                            
                                          },
                                          icon: const Icon(IconlyBold.arrowRight3),
                                          label: const Text("Confirm Order")),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                
                },
                icon: const Icon(IconlyBold.arrowRight),
                label: const Text("Proceed to checkout")),
                  ],
                ),
              );
            }
          }
        ));
  }

  Shimmer getproducteShimmerLoading() {
    final dummyProduct = Product.empty();
    final List<Product> dummyProductList = [dummyProduct];
    
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
          ...List.generate(2, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CartItem(cartItems: dummyProductList, cartItem: dummyProduct),
            );
          }),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
            ],
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
              onPressed: () {
                
              },
              icon: const Icon(IconlyBold.arrowRight),
              label: const Text("Proceed to checkout")),
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
