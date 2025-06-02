import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import 'package:intl/intl.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<Transaction> transactions;

  const MonthlyBarChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final monthlyTotals = _calculateMonthlyTotals();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Gastos Mensais',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                          final index = value.toInt();
                          final months = [
                            '', 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
                            'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
                          ];
                          return index >= 1 && index <= 12
                              ? Text(months[index])
                              : const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: monthlyTotals.entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: const Color(0xFF0A1D37),
                          width: 14,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<int, double> _calculateMonthlyTotals() {
    final Map<int, double> totals = {};

    for (var t in transactions) {
      if (t.type == 'saída') {
        int month = t.date.month;
        totals.update(month, (value) => value + t.amount, ifAbsent: () => t.amount);
      }
    }

    return totals;
  }
}
