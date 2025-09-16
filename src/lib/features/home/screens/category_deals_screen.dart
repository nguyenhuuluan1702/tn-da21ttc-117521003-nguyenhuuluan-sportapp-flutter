import 'package:flutter/material.dart';
import 'package:flutter_app_sport_three/common/widgets/loader.dart';
import 'package:flutter_app_sport_three/constants/global_veriables.dart';
import 'package:flutter_app_sport_three/features/home/services/home_services.dart';
import 'package:flutter_app_sport_three/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_app_sport_three/features/product_details/services/product_details_services.dart';
import 'package:flutter_app_sport_three/models/product.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({super.key, required this.category});

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();
  final ProductDetailsServices productDetailsServices = ProductDetailsServices();

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  fetchCategoryProducts() async {
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: widget.category,
    );
    setState(() {});
  }

  void addToCart(Product product) {
    productDetailsServices.addToCart(
      context: context,
      product: product,
    );

    // Hiển thị dialog thông báo
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color.fromARGB(255, 3, 232, 19),
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Thêm vào giỏ hàng thành công!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 9, 211, 43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          title: Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: productList == null
          ? const Loader()
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.topLeft,
                  // child: Text(
                  //   widget.category,
                  //   style: const TextStyle(
                  //     fontSize: 20,
                  //   ),
                  // ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: productList!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // 1 sản phẩm trên hàng
                      childAspectRatio: 0.6, // Điều chỉnh tỷ lệ chiều cao/rộng của item
                      mainAxisSpacing: 30, // Khoảng cách giữa các sản phẩm
                    ),
                    itemBuilder: (context, index) {
                      final product = productList![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductDetailScreen.routeName,
                            arguments: product,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(  // Thêm thuộc tính border
                              // ignore: deprecated_member_use
                              color: Colors.grey.withOpacity(0.5),  // Màu viền xám với độ trong suốt 0.5
                              width: 1.5,  // Độ dày viền 1.5
                            ),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 0,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hình ảnh sản phẩm
                              Expanded( // Wrap Image trong Expanded
                                flex: 3, // Chiếm 3/5 không gian
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    product.images[0],
                                    width: double.infinity,
                                    fit: BoxFit.contain, // Thay đổi thành contain
                                  ),
                                ),
                              ),
                              // Phần thông tin sản phẩm
                              Expanded( // Wrap thông tin trong Expanded
                                flex: 2, // Chiếm 2/5 không gian
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        product.name.toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      // Thêm phần mô tả ngắn ở đây
                                      Text(
                                        product.description,
                                        maxLines: 4, // Giới hạn 4 dòng
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      // Thay thế phần hiển thị giá bằng Column này
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${NumberFormat("#,###", "vi_VN").format(product.price * 1.2)}₫', // Giá gốc (ví dụ tăng 20%)
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              decoration: TextDecoration.lineThrough, // Gạch ngang
                                              decorationColor: Colors.grey,
                                              decorationThickness: 1.5,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${NumberFormat("#,###", "vi_VN").format(product.price)}₫', // Giá đã giảm
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                addToCart(product);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                              ),
                                              child: const Text(
                                                'THÊM VÀO GIỎ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8), // Khoảng cách giữa 2 nút
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  ProductDetailScreen.routeName,
                                                  arguments: product,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                              ),
                                              child: const Text(
                                                'XEM CHI TIẾT',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
