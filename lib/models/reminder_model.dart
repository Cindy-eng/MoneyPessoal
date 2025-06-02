// Removed cloud_firestore import
// Removed intl import (formatting should happen in UI)

class Reminder {
  final String? id;
  final String title;
  // final String description; // Description might not be used in the simplified UI, removed for now
  final double amount; // Added amount based on previous UI adaptation
  final DateTime dueDate; // Changed from Timestamp to DateTime
  final bool isPaid;

  Reminder({
    this.id,
    required this.title,
    // required this.description,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
  });

  // Removed fromFirestore factory
  // Removed toFirestore method

  // Example static method to generate mock data
  static List<Reminder> getMockReminders() {
    final now = DateTime.now();
    return [
      Reminder(
        id: 'mock_rem_1',
        title: 'Conta de Luz',
        dueDate: now.add(const Duration(days: 5)),
        amount: 150.75,
        isPaid: false,
      ),
      Reminder(
        id: 'mock_rem_2',
        title: 'Aluguel',
        dueDate: now.add(const Duration(days: 10)),
        amount: 1200.00,
        isPaid: false,
      ),
      Reminder(
        id: 'mock_rem_3',
        title: 'Internet',
        dueDate: now.subtract(const Duration(days: 2)), // Past due
        amount: 99.90,
        isPaid: true,
      ),
       Reminder(
        id: 'mock_rem_4',
        title: 'Cartão de Crédito',
        dueDate: now.add(const Duration(days: 15)),
        amount: 850.00,
        isPaid: false,
      ),
    ];
  }
}

