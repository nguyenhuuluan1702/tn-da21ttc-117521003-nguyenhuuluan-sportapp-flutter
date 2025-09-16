// import 'package:flutter/material.dart';
// import 'package:flutter_app_sport_three/common/widgets/loader.dart';
// import 'package:flutter_app_sport_three/constants/global_veriables.dart';
// import 'package:flutter_app_sport_three/features/account/services/account_services.dart';
// import 'package:flutter_app_sport_three/features/account/widgets/single_product.dart';
// import 'package:flutter_app_sport_three/features/orders_details/screens/order_details.dart';
// import 'package:flutter_app_sport_three/models/order.dart';

// class Orders extends StatefulWidget {
//   const Orders({super.key});

//   @override
//   State<Orders> createState() => _OrdersState();
// }

// class _OrdersState extends State<Orders> {
//   List<Order>? orders;
//   final AccountServices accountServices = AccountServices();

//   @override
//   void initState() {
//     super.initState();
//     fetchOrders();
//   }

//   void fetchOrders() async {
//     orders = await accountServices.fetchMyOrders(context: context);

//     if (orders != null && orders!.isNotEmpty) {
//       // Sắp xếp đơn mới nhất lên đầu
//       orders!.sort((a, b) => b.orderedAt.compareTo(a.orderedAt));
//     }

//     setState(() {});
//     // In log để kiểm tra có dữ liệu không
//     debugPrint("Số đơn hàng: ${orders?.length}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (orders == null) {
//       return const Loader();
//     }

//     if (orders!.isEmpty) {
//       return const Center(
//         child: Text("Chưa có đơn hàng nào."),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Đơn hàng của bạn'),
//         backgroundColor: GlobalVariables.selectedNavBarColor,
//       ),
//       body: GridView.builder(
//         itemCount: orders!.length,
//         padding: const EdgeInsets.all(10),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // 2 đơn mỗi hàng
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 0.8,
//         ),
//         itemBuilder: (context, index) {
//           final order = orders![index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.pushNamed(
//                 context,
//                 OrderDetailScreen.routeName,
//                 arguments: order,
//               );
//             },
//             child: Card(
//               elevation: 3,
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: SingleProduct(
//                       image: order.products[0].images[0],
///                     ),
///                   ),
///                   Padding(
//                     padding: const EdgeInsets.all(6.0),
//                     child: Column(
//                       children: [
//                         Text(
//                           'Mã: ${order.id.substring(0, 8)}...',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '${order.totalPrice}₫',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_app_sport_three/common/widgets/loader.dart';
// ignore: unused_import
import 'package:flutter_app_sport_three/constants/global_veriables.dart';
import 'package:flutter_app_sport_three/features/account/services/account_services.dart';
import 'package:flutter_app_sport_three/features/account/widgets/single_product.dart';
import 'package:flutter_app_sport_three/features/orders_details/screens/order_details.dart';
import 'package:flutter_app_sport_three/models/order.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);

    if (orders != null && orders!.isNotEmpty) {
      // Sắp xếp đơn mới nhất lên đầu
      orders!.sort((a, b) => b.orderedAt.compareTo(a.orderedAt));
    }

    setState(() {});
    // In log để kiểm tra có dữ liệu không
    debugPrint("Số đơn hàng: ${orders?.length}");
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Đơn hàng của bạn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                   
                  ],
                ),
              ),
              // Thay đổi phần hiển thị đơn hàng
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: orders!.length,
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
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // ignore: sized_box_for_whitespace
                              Container(
                                width: 80,
                                height: 80,
                                child: SingleProduct(
                                  image: orderData.products[0].images[0],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
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
                                      'Số lượng: ${orderData.quantity.reduce((a, b) => a + b)} sản phẩm',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Trạng thái: ${getStatusText(orderData.status)}',
                                      style: TextStyle(
                                        color: getStatusColor(orderData.status),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }

  // Thêm helper methods để xử lý trạng thái
  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Chưa xử lý';
      case 1:
        return 'Chờ lấy hàng';
      case 2:
        return 'Đang giao';
      case 3:
        return 'Đã giao';
      default:
        return 'Đã giao';
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

