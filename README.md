#  SportApp - Ứng dụng bán dụng cụ thể dục thể thao  

##  Giới Thiệu  
Dự án **SportApp** được xây dựng nhằm cung cấp một nền tảng mua sắm trực tuyến các dụng cụ thể dục thể thao ngay trên thiết bị di động.  

Ứng dụng được phát triển bằng **Flutter**, một bộ công cụ UI của Google để tạo ra các ứng dụng đẹp mắt và hiệu quả.  
Ngôn ngữ chính sử dụng là **Dart** – tối ưu hóa cho phát triển đa nền tảng.  

Phần **Backend** được xây dựng bằng **Node.js (Express.js)** để xử lý API, kết hợp với **MongoDB** để lưu trữ dữ liệu.  

---

##  Yêu Cầu Hệ Thống  

- **Hệ điều hành**: Windows, macOS hoặc Linux  
- **Bộ nhớ RAM**: Tối thiểu 8GB (Khuyến nghị 16GB)  
- **Bộ xử lý**: Intel hoặc AMD hỗ trợ x64-bit  
- **Yêu cầu khác**:  
  - Flutter SDK  
  - Dart SDK  
  - Android Studio (hoặc Xcode cho iOS) / Visual Studio Code (với Extensions Flutter & Dart)  
  - Kết nối Internet ổn định  
  - Node.js & npm  
  - MongoDB  

---

##  Cài Đặt  

### 1. Cài Đặt Flutter  
- **Tải về Flutter SDK**: Truy cập [Flutter.dev](https://flutter.dev) và tải bản phù hợp hệ điều hành.  
- **Thiết lập PATH**: Giải nén và thêm `flutter/bin` vào biến môi trường hệ thống.  
- **Kiểm tra cài đặt**:  
  ```bash
  flutter doctor
### 2. Cài Đặt Dart
Dart đã tích hợp sẵn trong Flutter SDK.

### 3. Cài Đặt IDE

Visual Studio Code (khuyến nghị): Cài đặt Extensions Flutter và Dart.

Android Studio: Dùng AVD Manager để tạo thiết bị ảo Android.

Có thể sử dụng thiết bị thật nếu cần giảm ram tiêu thụ khi test.

### 4. Cài Đặt Backend (Node.js + MongoDB)

Cài Node.js từ nodejs.org
.

Cài MongoDB từ mongodb.com
.

- Khởi chạy backend:
  ```bash
  cd server
  npm install
  npm run dev

## Tác giả
Họ và Tên: Nguyễn Hữu Luân

Email: nguyenhuuluantvtc@gmail.com

GitHub: nguyenhuuluan1702

SĐT: 0372170359
