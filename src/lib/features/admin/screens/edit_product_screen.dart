import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:flutter_app_sport_three/common/widgets/custom_button.dart';
import 'package:flutter_app_sport_three/common/widgets/custom_textfield.dart';
import 'package:flutter_app_sport_three/constants/global_veriables.dart';
import 'package:flutter_app_sport_three/features/admin/services/admin_services.dart';
import 'package:flutter_app_sport_three/models/product.dart';
import 'package:intl/intl.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';
  final Product product;
  
  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();

  String category = 'Thiết bị gym';
  List<String> images = [];
  final _editProductFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.product.name;
    descriptionController.text = widget.product.description;
    // Format giá khi hiển thị
    priceController.text = widget.product.price.toStringAsFixed(0);
    quantityController.text = widget.product.quantity.toString();
    category = widget.product.category;
    images = widget.product.images;
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  List<String> productCategories = [
    'Gym',
    'Calisthenics',
    'Yoga',
    'Sports',
    'Accessories',
  ];

  void updateProduct() {
    if (_editProductFormKey.currentState!.validate()) {
      // Chuyển đổi chuỗi nhập vào thành số
      String priceText = priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
      double price = double.parse(priceText);
      
      // Chuyển đổi số lượng thành số nguyên
      int quantity = int.parse(quantityController.text);

      adminServices.updateProduct(
        context: context,
        productId: widget.product.id!,
        name: productNameController.text,
        description: descriptionController.text,
        price: price,
        quantity: quantity,
        category: category,
        images: images,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Cập nhật sản phẩm',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _editProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Hiển thị ảnh sản phẩm
                cs.CarouselSlider(
                  items: images.map((i) {
                    return Builder(
                      builder: (BuildContext context) =>
                          Image.network(i, fit: BoxFit.cover, height: 200),
                    );
                  }).toList(),
                  options: cs.CarouselOptions(
                    viewportFraction: 1,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Tên sản phẩm',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Mô tả sản phẩm',
                  maxLines: 7,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    hintText: 'Giá (VD: 20000)',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black38,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Vui lòng nhập giá';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    hintText: 'Số lượng',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black38,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Vui lòng nhập số lượng';
                    }
                    // Kiểm tra có phải số không
                    if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                      return 'Vui lòng chỉ nhập số nguyên';
                    }
                    // Kiểm tra có phải số nguyên dương không
                    if (int.parse(val) <= 0) {
                      return 'Số lượng phải lớn hơn 0';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number, // Chỉ hiện bàn phím số
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>( // Thêm kiểu <String>
                    value: productCategories.contains(category) ? category : productCategories[0], // Kiểm tra value có tồn tại
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        category = newVal ?? productCategories[0];
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Cập nhật',
                  onTap: updateProduct,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}