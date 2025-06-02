// Removed cloud_firestore import

class Transaction {
  final String? id; // Keep ID for potential local list management
  final String type; // 'entrada' or 'saída'
  final String category;
  final double amount;
  final String description;
  final DateTime date; // Changed from Timestamp to DateTime

  Transaction({
    this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
  });

  // Removed fromFirestore factory
  // Removed toFirestore method

  // Example static method to generate mock data (can be moved to screens)
  static List<Transaction> getMockTransactions() {
    final now = DateTime.now();
    return [
      Transaction(id: 'mock1', type: 'saída', category: 'Alimentação', amount: 55.0, description: 'Almoço restaurante', date: now.subtract(const Duration(days: 1))),
      Transaction(id: 'mock2', type: 'entrada', category: 'Salário', amount: 5000.0, description: 'Salário Mensal', date: now.subtract(const Duration(days: 2))),
      Transaction(id: 'mock3', type: 'saída', category: 'Transporte', amount: 15.0, description: 'Ônibus', date: now.subtract(const Duration(hours: 5))),
      Transaction(id: 'mock4', type: 'saída', category: 'Lazer', amount: 120.0, description: 'Cinema', date: now.subtract(const Duration(days: 3))),
      Transaction(id: 'mock5', type: 'saída', category: 'Moradia', amount: 1200.0, description: 'Aluguel', date: now.subtract(const Duration(days: 5))),
    ];
  }
}

