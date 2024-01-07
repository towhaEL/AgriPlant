import 'dart:ui';

import 'package:agriplant/AdminPages/controller/admin_controller.dart';
import 'package:agriplant/models/order.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/AdminPages/widgets/order_product.dart';
import 'package:agriplant/models/user_model.dart';
import 'package:agriplant/utils/enum/extensions/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({super.key, required this.order, this.visibleProduct = 2, this.isClickable = true, required this.user});
  final Order order;
  final visibleProduct;
  final bool isClickable;
  final UserModel user;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  String dropdownValue = 'Processing';
  var items = [     
    'Processing', 
    'Picking', 
    'Shipping', 
    'Delivered', 
  ];
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
        final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101));
        if (picked != null && picked != selectedDate) {
            setState(() {
                selectedDate = picked;
            });
        }
    }

  bool onceOnly = true;
  @override
  Widget build(BuildContext context) {
    Get.delete<AdminController>();
    var adminController = Get.put(AdminController());
    
    if(onceOnly) {
      dropdownValue = widget.order.status.toString().substring(12);
      selectedDate = widget.order.deliveringDate;
      onceOnly = false;
    }
    final distinctProduct = getUniqueProducts(widget.order.products);
    // final products = order.products.take(2).toList();
    final products = distinctProduct.take(widget.visibleProduct).toList();
    final totalPrice = widget.order.products.fold(0.0, (acc, e) => acc + e.price);
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
                    ("Order: ${widget.order.id}#${widget.order.orderingDate.hashCode}"),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    "(${widget.order.products.length} Items)",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 5),
                  Text("\$${totalPrice.toStringAsFixed(2)}")
                ],
              ),
              const SizedBox(height: 20),
              ...List.generate(products.length, (index) {
                return OrderProduct(order: widget.order, product: products[index], isClickable: widget.isClickable);
              }),
              if (distinctProduct.length > 0 || widget.isClickable == false)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                              
                              Row(
                                children: [
                                  Text("Status",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 20,),
                                  DropdownButton( 
                                    value: dropdownValue, 
                                  
                                    // Down Arrow Icon 
                                    icon: const Icon(Icons.keyboard_arrow_down),     
                                  
                                    // Array list of items 
                                    items: items.map((String items) { 
                                      return DropdownMenuItem( 
                                        value: items, 
                                        child: Text(items), 
                                      ); 
                                    }).toList(), 
                                    // After selecting the desired option,it will 
                                    // change button value to selected value 
                                    onChanged: (String? newValue) {  
                                      setState(() { 
                                        dropdownValue = newValue!;
                                  
                                      }); 
                                    }, 
                                  ),
                                ],
                              ),
                          
                              ElevatedButton(
                                onPressed: () => _selectDate(context),
                                child: Text('Delivery Date\n${selectedDate.formatDate}'),
                              ),
                          
                          // TextButton.icon(
                          //   onPressed: () {
                              // showModalBottomSheet(
                              //     context: context,
                              //     showDragHandle: true,
                              //     barrierColor: Colors.white.withOpacity(.7),
                              //     isScrollControlled: true,
                              //     builder: (context) {
                              //       return ClipRect(
                              //         child: BackdropFilter(
                              //           filter: ImageFilter.blur(
                              //             sigmaX: 5,
                              //             sigmaY: 5,
                              //           ),
                              //           child: Container(
                              //             height:
                              //                 MediaQuery.of(context).size.height * .5,
                              //             child: ListView.builder(
                              //                 padding: const EdgeInsets.all(16),
                              //                 itemCount: distinctProduct.length,
                              //                 itemBuilder: (context, index) {
                              //                   return OrderProduct(
                              //                       order: widget.order,
                              //                       product: distinctProduct[index]);
                              //                 }),
                              //           ),
                              //         ),
                              //       );
                              //     });
                          //   },
                          //   label: const Text("View all"),
                          //   icon: const Icon(IconlyLight.arrowRight3),
                          // ),
                        ],
                      ),
                      TextButton.icon(
                            onPressed: () {
                              String status = dropdownValue;
                              String deliveringDate = selectedDate.toString();
                              Map<String, dynamic> updated_order = {'status': status, 'deliveringDate': deliveringDate};
                              adminController.updateSingleField(widget.user, widget.order.id, updated_order);
                            },
                            label: const Text("Confirm changes"),
                            icon: const Icon(IconlyLight.arrowRight3),
                          ),

                    ],
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
