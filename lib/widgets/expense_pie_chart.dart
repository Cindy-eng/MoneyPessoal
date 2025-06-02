import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> categoryData;

  const ExpensePieChart({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    final sections = categoryData.entries.map((entry) {
      return PieChartSectionData(
        color: _getColor(entry.key),
        value: entry.value,
        title: entry.key,
      );
    }).toList();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Despesas por Categoria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
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

  // Exemplo de cores fixas por categoria
  Color _getColor(String category) {
    switch (category) {
      case 'Alimentação':
        return Colors.red;
      case 'Transporte':
        return Colors.blue;
      case 'Lazer':
        return Colors.green;
      case 'Educação':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }
}
