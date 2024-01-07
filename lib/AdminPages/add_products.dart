import 'package:agriplant/AdminPages/widgets/form_container_widget.dart';
import 'package:agriplant/controllers/product_controller.dart';
import 'package:agriplant/models/product.dart';
import 'package:agriplant/pages/auth/global/common/toast.dart';
import 'package:agriplant/repositories/product_repository.dart';
import 'package:agriplant/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class addProducts extends StatefulWidget {
  const addProducts({super.key});

  @override
  State<addProducts> createState() => _addProductsState();
}

class _addProductsState extends State<addProducts> {
  // Get.delete<productController>();
  final userRepository = Get.put(UserRepository());
  final productRepository = Get.put(ProductRepository());

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();
  TextEditingController _stockController = TextEditingController();

  bool checkValue = false;
  bool _isSubmit = false;
  String dropdownvalue = 'Seeds'; 
  String unitvalue = 'day(s)'; 
  int serviceValue = 0;
  int unit = 0;   
  
  // List of items in our dropdown menu 
  var items = [     
    'Seeds', 
    'Seedlings', 
    'Machineries & Tools', 
    'Hire worker', 
  ];
  var unititems = [     
    'day(s)', 
    'kg', 
    'piece', 
    'hour(s)', 
  ];

  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Product",
        ),
        
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FormContainerWidget(
                controller: _nameController,
                hintText: "Product name",
              ),
              SizedBox(height: 20,),
              FormContainerWidget(
                controller: _descriptionController,
                hintText: "Product Description",
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select if product is featured"),
                  Checkbox(
                          value: checkValue,
                          onChanged: (bool? value) {
                            setState(() {
                              checkValue = value!;
                            });
                          },
                        ), 
                ]
              ),
              
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select Services"),
                  DropdownButton(  
              // Initial Value 
              value: dropdownvalue, 
                
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
                  dropdownvalue = newValue!;
                  switch (dropdownvalue) {
                    case 'Seeds':
                      serviceValue = 0;
                      break;
                    case 'Seedlings':
                      serviceValue = 1;
                      break;
                    case 'Machineries & Tools':
                      serviceValue = 2;
                      break;
                    case 'Hire worker':
                      serviceValue = 3;
                      break;
                  }
                  
                }); 
              }, 
            ),
                ],
              ),
              // Text(serviceValue.toString() + ' ' + dropdownvalue),
              SizedBox(height: 20,),
              FormContainerWidget(
                controller: _priceController,
                hintText: "Product price",
                inputType: TextInputType.number,
              ),
              SizedBox(height: 20,),
              FormContainerWidget(
                controller: _ratingController,
                hintText: "Product rating",
                inputType: TextInputType.number,
              ),
              SizedBox(height: 20,),
              FormContainerWidget(
                controller: _stockController,
                hintText: "Product stock",
                inputType: TextInputType.number,
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select product unit"),
                  
                  DropdownButton(  
              // Initial Value 
              value: unitvalue, 
                
              // Down Arrow Icon 
              icon: const Icon(Icons.keyboard_arrow_down),     
                
              // Array list of items 
              items: unititems.map((String unititems) { 
                return DropdownMenuItem( 
                  value: unititems, 
                  child: Text(unititems), 
                ); 
              }).toList(), 
              // After selecting the desired option,it will 
              // change button value to selected value 
              onChanged: (String? newValue) {  
                setState(() { 
                  unitvalue = newValue!;
                  // 
                }); 
              }, 
            ),
                ],
              ),
              // Text(serviceValue.toString() + ' ' + unitvalue),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Upload product image"),
                  ElevatedButton.icon(
                  onPressed: () async {
                    image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 512, maxWidth: 512);
                    if(image != null) {
                      showToast(message: 'Image uploaded');
                    }
                  }, 
                  icon: Icon(Icons.camera), 
                  label: Text("Upload"))
                ],
              ),
              SizedBox(height: 50,),
              FilledButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () {
                  addProduct();
                },
                child: _isSubmit ? CircularProgressIndicator(
                      color: Colors.white,): Text("Submit", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
              ),
              
            ],
          )
        ],
      )
    );
  }


  addProduct() async {
    setState(() {
      _isSubmit = true;
    });

    final productController = Get.put(ProductController());
    String name = _nameController.text;
    String description = _descriptionController.text;
    int serviceCode = serviceValue;
    double price = double.parse(_priceController.text);
    double rating = double.parse(_ratingController.text);
    int stock = int.parse(_stockController.text);
    String unit = unitvalue;
    String imageUrl = '';

    if(image != null) {
    // imageUploading.value = true;
    imageUrl = await userRepository.uploadImage('Products/Images/Thumbnails/', image!);
  }

  final newProduct = Product(
    productCode: -1, 
    serviceCode: serviceCode, 
    name: name, 
    description: description, 
    image: imageUrl, 
    price: price, 
    unit: unit, 
    rating: rating, 
    stock: stock,
    isFeatured: checkValue,
    );

    productController.addNewProduct(newProduct);

    setState(() {
      _isSubmit = false;
    });

  }

  


}