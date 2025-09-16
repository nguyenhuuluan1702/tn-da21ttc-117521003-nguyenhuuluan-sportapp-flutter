import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_sport_three/providers/user_provider.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy user từ provider
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin tài khoản"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text("Tên người dùng"),
                subtitle: Text(user.name.isNotEmpty ? user.name : "Chưa có dữ liệu"),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.green),
                title: const Text("Email"),
                subtitle: Text(user.email.isNotEmpty ? user.email : "Chưa có dữ liệu"),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.orange),
                title: const Text("Địa chỉ"),
                subtitle: Text(user.address.isNotEmpty ? user.address : "Chưa có dữ liệu"),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.badge, color: Colors.purple),
                title: const Text("Loại tài khoản"),
                subtitle: Text(user.type.isNotEmpty ? user.type : "Người dùng thường"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
