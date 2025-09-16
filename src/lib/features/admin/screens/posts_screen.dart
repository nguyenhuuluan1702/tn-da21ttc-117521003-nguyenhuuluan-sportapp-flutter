import 'package:flutter/material.dart';
import 'package:flutter_app_sport_three/common/widgets/loader.dart';
import 'package:flutter_app_sport_three/features/account/services/account_services.dart';
import 'package:flutter_app_sport_three/features/account/widgets/single_product.dart';
import 'package:flutter_app_sport_three/features/admin/screens/add_product_screen.dart';
import 'package:flutter_app_sport_three/features/admin/screens/edit_product_screen.dart';
import 'package:flutter_app_sport_three/features/admin/services/admin_services.dart';
import 'package:flutter_app_sport_three/models/product.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();
  String? selectedCategory; // Thêm biến để lưu danh mục được chọn

  // Danh sách các danh mục
  final List<String> categories = [
    'Gym',
    'Calisthenics',
    'Yoga',
    'Sports',
    'Accessories',
  ];

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  // Hàm lọc sản phẩm theo danh mục
  void filterProductsByCategory(String category) {
    setState(() {
      selectedCategory = category == 'Tất cả' ? null : category;
    });
    fetchAllProducts(); // Tải lại danh sách sản phẩm
  }

  @override
  Widget build(BuildContext context) {
    // Lọc sản phẩm theo danh mục được chọn
    final filteredProducts = selectedCategory == null
        ? products
        : products
              ?.where((product) => product.category == selectedCategory)
              .toList();

    return products == null
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Quản lý sản phẩm'),
              // Thay đổi actions thành leading để thêm nút menu
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
            // Thêm drawer vào đây
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text(
                      'Menu Quản lý',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Thêm sản phẩm mới'),
                    onTap: () {
                      Navigator.pop(context); // Đóng drawer
                      navigateToAddProduct();
                    },
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Lọc theo danh mục:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.all_inbox,
                      color: selectedCategory == null
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    title: const Text('Tất cả'),
                    selected: selectedCategory == null,
                    onTap: () {
                      Navigator.pop(context);
                      filterProductsByCategory('Tất cả');
                    },
                  ),
                  ...categories
                      .map(
                        (category) => ListTile(
                          leading: Icon(
                            Icons.category,
                            color: selectedCategory == category
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          title: Text(category),
                          selected: selectedCategory == category,
                          onTap: () {
                            Navigator.pop(context);
                            filterProductsByCategory(category);
                          },
                        ),
                      )
                      .toList(),
                  const Divider(),
                  // 👉 Nút đăng xuất thêm ở cuối
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Đăng xuất'),
                    onTap: () {
                      Navigator.pop(context); // Đóng drawer
                      AccountServices().logOut(context); // Gọi hàm logout
                    },
                  ),
                ],
              ),
            ),
            body: GridView.builder(
              itemCount: filteredProducts?.length ?? 0,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final productData = filteredProducts![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(image: productData.images[0]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            productData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: () => deleteProduct(productData, index),
                          icon: const Icon(Icons.delete_outline),
                        ),
                        // Trong widget hiển thị sản phẩm
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              EditProductScreen.routeName,
                              arguments: productData,
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
  }
}
