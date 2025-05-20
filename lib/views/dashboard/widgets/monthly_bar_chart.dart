import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyBarChart extends StatelessWidget {
  const MonthlyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Gastos Mensais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun'];
                          return Text(months[value.toInt()]);
                        },
                        interval: 1,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 1200, color: Color(0xFF0A1D37))]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 900, color: Color(0xFF0A1D37))]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 1400, color: Color(0xFF0A1D37))]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 1100, color: Color(0xFF0A1D37))]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 800, color: Color(0xFF0A1D37))]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 1000, color: Color(0xFF0A1D37))]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
