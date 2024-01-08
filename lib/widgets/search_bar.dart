import 'package:agriplant/data/services.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/pages/product_details_page.dart';
import 'package:agriplant/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_search/overlay_search.dart';


class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key, required this.overlayController});
  final OverlaySearchController overlayController;

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  final _productRepository = Get.put(ProductRepository());
  bool? isLoading = false;
  List<Product> list = [];
  Product product = Product.empty();

  @override
  Widget build(BuildContext context) {
    return 
    SearchWithList(
      overlaySearchController: widget.overlayController,
      list: list
          .map(
            (e) => OverlayItemModel(
              title: e.name,
              content: services[e.serviceCode].name,
              id: e.productCode.toString(),
            ),
          )
          .toList(),
      isLoading: isLoading,
      hintStyle: Theme.of(context).textTheme.bodyMedium,
      overlayBackgroundColor: Colors.white,
      // searchBackgroundColor: Colors.white,

      hint: "Search product",
      // focusedHint: "focusedHint",
      suffixAction: () {
        widget.overlayController.hideOverlay();
        widget.overlayController.clearSearchQuery();
      },
      notFoundText: "Stock Not Found",
      onItemSelected: (item) async {

        for (var p in list) {
          if (p.productCode == int.parse(item.id.toString())) {
            product = p;
          } 
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              product: product,
            ),
          ),
        );
      },
      contentStyle: TextStyle(color: Colors.green),
      
      enableDebounce: true,
      debounceDuration: const Duration(milliseconds: 2200),
      onChanged: (p0) {
        print(p0);
        _fetchSearchWithKey(p0);
      },
      onTap: () {
        _fetchSearch();
      },
    );
    
  }

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  _fetchSearch() async {
    if (list.isNotEmpty) return;
    try {
      setLoading(true);

      list = await _productRepository.getAllProducts();
      setLoading(false);
    } catch (e) {
      setLoading(false);
    }
  }

  _fetchSearchWithKey(String value) {

  }

}
