import 'package:flutter/material.dart';
import 'package:flutter_app_sport_three/features/account/screens/admin_info_screen.dart';
import 'package:flutter_app_sport_three/features/account/screens/user_info_screen.dart';
import 'package:flutter_app_sport_three/features/account/services/account_services.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ExpansionTile(
        leading: const Icon(Icons.menu, color: Colors.blue),
        title: const Text(
          "Tùy chọn",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.blue),
            title: const Text("Đơn hàng của bạn"),
            onTap: () {
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.newspaper, color: Colors.green),
          //   title: const Text("Tin tức"),
          //   onTap: () {
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.red),
            title: const Text("Thông tin tài khoản"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserInfoScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: Color.fromARGB(255, 10, 213, 41)),
            title: const Text("Thông tin liên hệ"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminInfoScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black87),
            title: const Text("Đăng xuất"),
            onTap: () => AccountServices().logOut(context),
          ),
        ],
      ),
    );
  }
}
