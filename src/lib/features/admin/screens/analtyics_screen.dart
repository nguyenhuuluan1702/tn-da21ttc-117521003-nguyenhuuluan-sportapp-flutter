// ignore_for_file: unused_import

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // Thêm để định dạng tiền tệ
import 'package:flutter_app_sport_three/common/widgets/loader.dart';
import 'package:flutter_app_sport_three/features/admin/models/sales.dart';
import 'package:flutter_app_sport_three/features/admin/services/admin_services.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  // Sửa lại phương thức getEarnings
  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    setState(() {
      totalSales = earningData['totalEarnings'];
      earnings = (earningData['sales'] as List<Sales>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const CustomLoader()
        : SingleChildScrollView( // Thêm SingleChildScrollView ở đây
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề tổng doanh thu
                  Text(
                    'Tổng doanh thu: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(totalSales)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tiêu đề biểu đồ
                  const Text(
                    'Thống kê doanh thu theo danh mục',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Biểu đồ trong Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _getMaxEarning(),
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              // ignore: deprecated_member_use
                              getTooltipColor: (BarChartGroupData group) => Colors.blueAccent.withOpacity(0.8), 
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  '${earnings![groupIndex].label}\n${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(rod.toY)}',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    NumberFormat.compactCurrency(locale: 'vi_VN', symbol: '').format(value),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < earnings!.length) {
                                    return Transform.rotate(
                                      angle: -45 * 3.14 / 180, // Xoay nhãn 45 độ
                                      child: Text(
                                        earnings![index].label,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: _getMaxEarning() / 5 > 0 ? _getMaxEarning() / 5 : 20, // Thêm điều kiện kiểm tra
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
                          ),
                          barGroups: _buildBarGroups(),
                        ),
                        swapAnimationDuration: const Duration(milliseconds: 500),
                        swapAnimationCurve: Curves.easeInOut,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Phân bố sản phẩm theo danh mục',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      height: 300,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                                sections: [
                                  PieChartSectionData(
                                    value: 30, // Thiết bị gym
                                    title: '30%',
                                    color: Colors.blue,
                                    radius: 100,
                                  ),
                                  PieChartSectionData(
                                    value: 25, // Dụng cụ gym tại nhà
                                    title: '25%',
                                    color: Colors.green,
                                    radius: 100,
                                  ),
                                  PieChartSectionData(
                                    value: 20, // Yoga
                                    title: '20%',
                                    color: Colors.orange,
                                    radius: 100,
                                  ),
                                  PieChartSectionData(
                                    value: 15, // Dụng cụ thể thao ngoài trời
                                    title: '15%',
                                    color: Colors.purple,
                                    radius: 100,
                                  ),
                                  PieChartSectionData(
                                    value: 10, // Phụ kiện liên quan
                                    title: '10%',
                                    color: Colors.red,
                                    radius: 100,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLegendItem('Thiết bị gym', Colors.blue, '30%'),
                                _buildLegendItem('Dụng cụ gym tại nhà', Colors.green, '25%'),
                                _buildLegendItem('Yoga', Colors.orange, '20%'),
                                _buildLegendItem('Dụng cụ thể thao ngoài trời', Colors.purple, '15%'),
                                _buildLegendItem('Phụ kiện liên quan', Colors.red, '10%'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  // Sửa lại phương thức _getMaxEarning
  double _getMaxEarning() {
    if (earnings == null || earnings!.isEmpty) return 100;
    final maxVal = earnings!.map((e) => e.earning.toDouble()).reduce(max);
    return maxVal + (maxVal * 0.2); // Thêm 20% để có khoảng trống phía trên
  }

  // Sửa lại phương thức _buildBarGroups
  List<BarChartGroupData> _buildBarGroups() {
    if (earnings == null || earnings!.isEmpty) return [];
    
    return earnings!.asMap().entries.map((entry) {
      final index = entry.key;
      final sales = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: sales.earning.toDouble(),
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.cyanAccent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 20,
            borderRadius: BorderRadius.circular(6),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxEarning(),
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
      );
    }).toList();
  }

  // Thêm widget helper để tạo mục chú thích
  Widget _buildLegendItem(String label, Color color, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            percentage,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Loader tùy chỉnh
class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        strokeWidth: 5,
      ),
    );
  }
}

