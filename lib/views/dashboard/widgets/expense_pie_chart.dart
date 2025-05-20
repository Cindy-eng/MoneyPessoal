import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensePieChart extends StatelessWidget {
  const ExpensePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Despesas por Categoria', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(color: Colors.red, value: 40, title: 'Alimentação'),
                    PieChartSectionData(color: Colors.blue, value: 30, title: 'Transporte'),
                    PieChartSectionData(color: Colors.green, value: 15, title: 'Lazer'),
                    PieChartSectionData(color: Colors.orange, value: 15, title: 'Outros'),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
