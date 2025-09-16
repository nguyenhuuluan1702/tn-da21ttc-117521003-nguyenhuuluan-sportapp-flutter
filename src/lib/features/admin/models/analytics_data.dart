import 'dart:convert';

class AnalyticsData {
  final double dailyRevenue;
  final double weeklyRevenue;
  final double monthlyRevenue;
  final int newOrders;
  final int newCustomers;
  final double completionRate;
  final int totalProducts;
  final int lowStockProducts;
  final Map<String, double> categoryRevenue;
  final List<TopProduct> topProducts;

  AnalyticsData({
    required this.dailyRevenue,
    required this.weeklyRevenue,
    required this.monthlyRevenue,
    required this.newOrders,
    required this.newCustomers,
    required this.completionRate,
    required this.totalProducts,
    required this.lowStockProducts,
    required this.categoryRevenue,
    required this.topProducts,
  });

  Map<String, dynamic> toMap() {
    return {
      'dailyRevenue': dailyRevenue,
      'weeklyRevenue': weeklyRevenue,
      'monthlyRevenue': monthlyRevenue,
      'newOrders': newOrders,
      'newCustomers': newCustomers,
      'completionRate': completionRate,
      'totalProducts': totalProducts,
      'lowStockProducts': lowStockProducts,
      'categoryRevenue': categoryRevenue,
      'topProducts': topProducts.map((x) => x.toMap()).toList(),
    };
  }

  factory AnalyticsData.fromMap(Map<String, dynamic> map) {
    return AnalyticsData(
      dailyRevenue: map['dailyRevenue']?.toDouble() ?? 0.0,
      weeklyRevenue: map['weeklyRevenue']?.toDouble() ?? 0.0,
      monthlyRevenue: map['monthlyRevenue']?.toDouble() ?? 0.0,
      newOrders: map['newOrders']?.toInt() ?? 0,
      newCustomers: map['newCustomers']?.toInt() ?? 0,
      completionRate: map['completionRate']?.toDouble() ?? 0.0,
      totalProducts: map['totalProducts']?.toInt() ?? 0,
      lowStockProducts: map['lowStockProducts']?.toInt() ?? 0,
      categoryRevenue: Map<String, double>.from(map['categoryRevenue'] ?? {}),
      topProducts: List<TopProduct>.from(
        map['topProducts']?.map((x) => TopProduct.fromMap(x)) ?? [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AnalyticsData.fromJson(String source) =>
      AnalyticsData.fromMap(json.decode(source));
}

class TopProduct {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int soldQuantity;
  final double revenue;

  TopProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.soldQuantity,
    required this.revenue,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'soldQuantity': soldQuantity,
      'revenue': revenue,
    };
  }

  factory TopProduct.fromMap(Map<String, dynamic> map) {
    return TopProduct(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      soldQuantity: map['soldQuantity']?.toInt() ?? 0,
      revenue: map['revenue']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TopProduct.fromJson(String source) =>
      TopProduct.fromMap(json.decode(source));
}