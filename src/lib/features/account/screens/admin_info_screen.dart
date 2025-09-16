import 'package:flutter/material.dart';

class AdminInfoScreen extends StatelessWidget {
  const AdminInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liên hệ"),
        backgroundColor: const Color.fromARGB(255, 10, 139, 187), // giống màu chủ đạo trong ảnh
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.facebook, color: Colors.red),
            title: const Text('Facebook'),
            subtitle: const Text('Tsport Official'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.red),
            title: const Text('Website'),
            subtitle: const Text('https://www.tsport.vn'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.red),
            title: const Text('Email'),
            subtitle: const Text('tsport@gmail.com'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.credit_card, color: Colors.red),
            title: const Text('Tư vấn sản phẩm'),
            subtitle: const Text('1900 633 999'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.red),
            title: const Text('Hoàn trả hàng'),
            subtitle: const Text('1900 633 633'),
          ),
        ],
      ),
    );
  }
}
