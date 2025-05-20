import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

import '../../screens/login/tela_login.dart' show TelaLogin;

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0A1D37),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0A1D37)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_circle, color: Colors.white, size: 48),
                SizedBox(height: 10),
                Text('Olá, Usuário!',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
          _buildItem(context, Icons.add_circle, 'Transação', '/add_transaction'),
          _buildItem(context, Icons.pie_chart, 'Orçamentos', '/budgets'),
          _buildItem(context, Icons.flag, 'Metas', '/goals'),
          _buildItem(context, Icons.notifications, 'Lembretes', '/reminders'),
          _buildItem(context, Icons.bar_chart, 'Relatórios', '/reports'),
          _buildItem(context, Icons.person, 'Perfil', '/profile'),
          const Divider(color: Colors.white70),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Sair', style: TextStyle(color: Colors.white)),
            onTap: () {
              FirebaseAuth.instance.signOut();
             // Navigator.pushReplacementNamed(context, '/login');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const TelaLogin()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String label, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
