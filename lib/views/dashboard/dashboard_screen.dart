import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Keep for charts
import 'package:intl/intl.dart'; // Keep for formatting

// Import simplified models and widgets (adjust paths if needed)
import '../../models/transaction_model.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/expense_pie_chart.dart';
import '../../widgets/monthly_bar_chart.dart';
import '../../widgets/quick_action_button.dart';
import '../../widgets/app_drawer.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // --- Mock Data --- 
  // (Ideally, fetch this once, maybe in initState or build, but keep it simple for now)
  final List<Transaction> _mockTransactions = Transaction.getMockTransactions();
  late double _currentBalance;
  late Map<String, double> _expensesByCategory;

  @override
  void initState() {
    super.initState();
    _calculateMockData();
  }

  void _calculateMockData() {
    double balance = 0;
    Map<String, double> categoryExpenses = {};

    for (var t in _mockTransactions) {
      if (t.type == 'entrada') {
        balance += t.amount;
      } else {
        balance -= t.amount;
        categoryExpenses.update(t.category, (value) => value + t.amount, ifAbsent: () => t.amount);
      }
    }
    _currentBalance = balance;
    _expensesByCategory = categoryExpenses;
  }

  // --- Build Method --- 
  @override
  Widget build(BuildContext context) {
    // Removed Provider access

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard (Screens Only)'),
        // Theme applied globally
      ),
      // AppDrawer needs to be simplified or passed mock user data
      drawer: const AppDrawer(mockUserName: 'Usuário Mock'), 
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Removed loading/error checks related to providers
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Use local mock data
                    BalanceCard(balance: _currentBalance),
                    const SizedBox(height: 20),
                    // Pass local mock data to charts
                    ExpensePieChart(categoryData: _expensesByCategory),
                    const SizedBox(height: 20),
                    MonthlyBarChart(transactions: _mockTransactions),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: const [
                        QuickActionButton(
                          icon: Icons.add_circle_outline,
                          label: 'Transação',
                          route: '/add_transaction',
                        ),
                        QuickActionButton(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Orçamentos',
                          route: '/budgets',
                        ),
                        QuickActionButton(
                          icon: Icons.savings_outlined,
                          label: 'Metas',
                          route: '/goals',
                        ),
                        QuickActionButton(
                          icon: Icons.notifications_outlined,
                          label: 'Lembretes',
                          route: '/reminders',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate and potentially pass a callback to update mock data if needed
          Navigator.pushNamed(context, '/add_transaction');
          // Note: Without state management, refreshing data after adding 
          // a transaction requires manual handling (e.g., passing callbacks or 
          // re-fetching mock data on screen return, which isn't implemented here).
        },
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Transação',
      ),
    );
  }
}

