import 'package:agriplant/models/product.dart';
import 'package:agriplant/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class productList extends StatefulWidget {
  const productList({super.key, required this.products});
  final List<Product> products;

  @override
  State<productList> createState() => _productListState();
}

class _productListState extends State<productList> {
  bool onlyOnce = true;
  bool filterVisible = false;
  List<bool> isSelected = [false, false, false, false];
  int serviceCode = -1;


  late List<Product> mainProductList = <Product>[];
  late List<Product> displayList = List.from(mainProductList);
  void updateList(String value) {
    setState(() {
          displayList = displayList.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
    }
    );
  }
  void updateFilterList(value) {
    setState(() {
      if (value == -1) {
        displayList = mainProductList;
      } else {
        displayList = mainProductList.where((element) => element.serviceCode.isEqual(value)).toList();
      }
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    
    if(onlyOnce) {
      mainProductList = widget.products;
      onlyOnce = false;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Products list",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      updateList(value);
                    },

                    decoration: InputDecoration(
                      hintText: "Search here...",
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(99),
                        ),
                      ),
                      prefixIcon: const Icon(IconlyLight.search),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: IconButton.filled(
                    onPressed: () {
                      setState(() {
                        filterVisible = !filterVisible;
                        isSelected = [false, false, false, false];
                        updateFilterList(-1);
                      });
                    },
                    icon: const Icon(
                      IconlyLight.filter,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            child: Center(
              // padding: const EdgeInsets.only(bottom: 10.0),
              child: Visibility(
                visible: filterVisible,
                child: 
                    ToggleButtons(
                    borderRadius: BorderRadius.circular(20),
                    borderColor: Colors.black,
                    selectedBorderColor: Colors.black,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    children: <Widget> [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:12, ),
                        child: Text('Seeds &\nSeedlings'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:12, ),
                        child: Text('Fruits &\nVeggies'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:12, ),
                        child: Text('Machineries\n& Tools'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:12, ),
                        child: Text('Hire Worker'),
                      ),
                    ], onPressed: (int index){
                      setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == index;
                }
                serviceCode = index;
                updateFilterList(index);
              });         
                    },
                    isSelected: isSelected),
                  
              ),
            ),
          ),

          SizedBox(height: 10,),

      
              GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  product: displayList[index],
                );
              },
            ),
              
            
          
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

