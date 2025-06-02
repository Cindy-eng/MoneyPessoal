import 'package:flutter/material.dart';

// Removed Provider import

class AppDrawer extends StatelessWidget {
  // Accept mock data as parameters
  final String mockUserName;

  const AppDrawer({super.key, required this.mockUserName});

  // Helper method to build drawer items
  Widget _buildDrawerItem(BuildContext context, IconData icon, String label, String route) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).primaryColorLight : Colors.white),
      title: Text(label, style: TextStyle(color: isSelected ? Theme.of(context).primaryColorLight : Colors.white)),
      tileColor: isSelected ? Colors.white.withOpacity(0.1) : null,
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (!isSelected) {
          // Use pushReplacementNamed to avoid back stack buildup for main sections
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Removed Provider access

    return Drawer(
      backgroundColor: const Color(0xFF0A1D37),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF0A1D37)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.account_circle, color: Colors.white, size: 60),
                const SizedBox(height: 10),
                Text(
                  // Use mock username passed as parameter
                  'Olá, $mockUserName!',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          _buildDrawerItem(context, Icons.dashboard_outlined, 'Dashboard', '/dashboard'),
          _buildDrawerItem(context, Icons.account_balance_wallet_outlined, 'Orçamentos', '/budgets'),
          _buildDrawerItem(context, Icons.savings_outlined, 'Metas', '/goals'),
          _buildDrawerItem(context, Icons.notifications_outlined, 'Lembretes', '/reminders'),
          _buildDrawerItem(context, Icons.person_outline, 'Perfil', '/profile'),
          const Divider(color: Colors.white30, height: 20, thickness: 0.5),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Sair', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Navigate directly to login screen on logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}

