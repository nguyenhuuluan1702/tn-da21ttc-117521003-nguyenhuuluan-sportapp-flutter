import 'package:flutter/material.dart';
import 'package:flutter_app_sport_three/common/widgets/loader.dart';
import 'package:flutter_app_sport_three/features/account/services/account_services.dart';
import 'package:flutter_app_sport_three/features/account/widgets/account_button.dart';
import 'package:flutter_app_sport_three/features/account/widgets/single_product.dart';
import 'package:flutter_app_sport_three/features/admin/services/admin_services.dart';
import 'package:flutter_app_sport_three/features/orders_details/screens/order_details.dart';
import 'package:flutter_app_sport_three/models/order.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    orders!.sort((a, b) => b.orderedAt.compareTo(a.orderedAt));
    setState(() {});
  }

  // Thêm helper method để lấy màu theo trạng thái
  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.grey.shade200; // Chưa xử lý
      case 1:
        return Colors.blue.shade100; // Chờ lấy hàng
      case 2:
        return Colors.orange.shade100; // Đang giao
      case 3:
        return Colors.green.shade100; // Đã giao
      default:
        return Colors.white;
    }
  }

  // Thêm helper method để lấy text trạng thái
  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Chưa xử lý';
      case 1:
        return 'Chờ lấy hàng';
      case 2:
        return 'Đang giao';
      case 3:
        return 'Đang giao';
      default:
        return 'Đã giao';
    }
  }

  // Thêm method showDeleteDialog
  void showDeleteDialog(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa đơn hàng này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              adminServices.deleteOrder(
                context: context,
                order: order,
                onSuccess: () {
                  Navigator.pop(context);
                  fetchOrders(); // Tải lại danh sách đơn hàng
                },
              );
            },
            child: const Text(
              'Có',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: orders!.length,
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final orderData = orders![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          OrderDetailScreen.routeName,
                          arguments: orderData,
                        );
                      },
                      child: Card(
                        elevation: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            color: getStatusColor(orderData.status),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SingleProduct(
                                  image: orderData.products[0].images[0],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mã đơn: ${orderData.id.substring(0, 8)}...',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'vi_VN',
                                        symbol: '₫',
                                        decimalDigits: 0,
                                      ).format(orderData.totalPrice),
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(orderData.status),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      child: Text(
                                        getStatusText(orderData.status),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: orderData.status == 3
                                              ? Colors.green
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          onPressed: () =>
                                              showDeleteDialog(orderData),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // SizedBox(
              //   height: 40,
              //   child: AccountButton(
              //     text: 'Đăng xuất',
              //     onTap: () => AccountServices().logOut(context),
              //   ),
              // ),
              // const SizedBox(height: 10),
            ],
          );
  }
}
