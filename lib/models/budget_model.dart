// Removed cloud_firestore import
// Removed intl import (not needed for basic model)

class Budget {
  final String? id;
  final String category;
  final double limit;
  final String month; // Format: "YYYY-MM"
  final double currentSpending; // Example: You might calculate this separately

  Budget({
    this.id,
    required this.category,
    required this.limit,
    required this.month,
    this.currentSpending = 0.0,
  });

  // Removed fromFirestore factory
  // Removed toFirestore method

  // Example static method to generate mock data
  static List<Budget> getMockBudgets() {
    final currentMonth = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}";
    return [
      Budget(id: 'mock_b1', category: 'Alimentação', limit: 800.0, month: currentMonth, currentSpending: 350.50),
      Budget(id: 'mock_b2', category: 'Transporte', limit: 200.0, month: currentMonth, currentSpending: 180.20),
      Budget(id: 'mock_b3', category: 'Lazer', limit: 400.0, month: currentMonth, currentSpending: 410.00),
      Budget(id: 'mock_b4', category: 'Moradia', limit: 1500.0, month: currentMonth, currentSpending: 1200.00),
    ];
  }
}

