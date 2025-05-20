import 'package:flutter/material.dart';
import 'widgets/balance_card.dart';
import 'widgets/expense_pie_chart.dart';
import 'widgets/monthly_bar_chart.dart';
import 'widgets/quick_action_button.dart';
import 'widgets/app_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF0A1D37),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BalanceCard(balance: 3250.50),
                    const SizedBox(height: 20),
                    const ExpensePieChart(),
                    const SizedBox(height: 20),
                    const MonthlyBarChart(),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: const [
                        QuickActionButton(
                          icon: Icons.add_circle,
                          label: 'Transação',
                          route: '/add_transaction',
                        ),
                        QuickActionButton(
                          icon: Icons.notifications_active,
                          label: 'Lembretes',
                          route: '/reminders',
                        ),
                        QuickActionButton(
                          icon: Icons.bar_chart,
                          label: 'Relatórios',
                          route: '/reports',
                        ),
                        QuickActionButton(
                          icon: Icons.person,
                          label: 'Perfil',
                          route: '/profile',
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
    );
  }
}
