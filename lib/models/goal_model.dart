// Removed cloud_firestore import
// Removed intl import (formatting should happen in UI)

class Goal {
  final String? id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline; // Changed from Timestamp to DateTime

  Goal({
    this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
  });

  // Removed fromFirestore factory
  // Removed toFirestore method

  // Helper to calculate progress (remains the same)
  double get progress => (targetAmount > 0) ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  // Example static method to generate mock data
  static List<Goal> getMockGoals() {
    final now = DateTime.now();
    return [
      Goal(
        id: 'mock_goal_1',
        name: 'Viagem para a Praia',
        targetAmount: 5000.00,
        currentAmount: 1250.50,
        deadline: now.add(const Duration(days: 90)),
      ),
      Goal(
        id: 'mock_goal_2',
        name: 'Novo Celular',
        targetAmount: 3500.00,
        currentAmount: 3100.00,
        deadline: now.add(const Duration(days: 45)),
      ),
      Goal(
        id: 'mock_goal_3',
        name: 'Curso de Inglês',
        targetAmount: 2000.00,
        currentAmount: 2000.00,
        deadline: now.add(const Duration(days: 15)),
      ),
    ];
  }
}

