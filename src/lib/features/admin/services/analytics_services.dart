import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_sport_three/features/admin/models/analytics_data.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_app_sport_three/constants/error_handling.dart';
import 'package:flutter_app_sport_three/constants/global_veriables.dart';
import 'package:flutter_app_sport_three/constants/utils.dart';
import 'package:flutter_app_sport_three/providers/user_provider.dart';
import 'package:flutter_app_sport_three/models/order.dart';
import 'package:flutter_app_sport_three/models/product.dart';

class AnalyticsServices {
  // Lấy thống kê tổng quan
  Future<Map<String, dynamic>> getOverviewStats({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Map<String, dynamic> stats = {};
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics/overview'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          stats = jsonDecode(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return stats;
  }

  // Lấy dữ liệu doanh thu theo thời gian
  Future<List<Map<String, dynamic>>> getRevenueData({
    required BuildContext context,
    String period = 'month', // 'day', 'week', 'month', 'year'
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Map<String, dynamic>> revenueData = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics/revenue?period=$period'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var data = jsonDecode(res.body);
          revenueData = List<Map<String, dynamic>>.from(data);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return revenueData;
  }

  // Lấy top sản phẩm bán chạy
  Future<List<Map<String, dynamic>>> getTopProducts({
    required BuildContext context,
    int limit = 5,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Map<String, dynamic>> topProducts = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics/top-products?limit=$limit'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var data = jsonDecode(res.body);
          topProducts = List<Map<String, dynamic>>.from(data);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return topProducts;
  }

  // Lấy thống kê đơn hàng
  Future<Map<String, dynamic>> getOrderStats({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Map<String, dynamic> orderStats = {};
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics/orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          orderStats = jsonDecode(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderStats;
  }

  // Lấy thống kê khách hàng
  Future<Map<String, dynamic>> getCustomerStats({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Map<String, dynamic> customerStats = {};
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics/customers'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          customerStats = jsonDecode(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return customerStats;
  }

  Future<AnalyticsData> getAnalyticsData(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    AnalyticsData analyticsData = AnalyticsData(
      dailyRevenue: 0,
      weeklyRevenue: 0,
      monthlyRevenue: 0,
      newOrders: 0,
      newCustomers: 0,
      completionRate: 0,
      totalProducts: 0,
      lowStockProducts: 0,
      categoryRevenue: {},
      topProducts: [],
    );

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics/overview'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          analyticsData = AnalyticsData.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return analyticsData;
  }
}