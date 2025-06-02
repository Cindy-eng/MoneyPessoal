import 'package:flutter/material.dart';

// Removed Provider imports

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  // Mock user data
  final String _mockEmail = 'mock.user@example.com';
  String _mockName = 'Usuário Mock';

  @override
  void initState() {
    super.initState();
    // Load initial mock name
    _nameController.text = _mockName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateName() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() { _isLoading = true; });

      // Simulate update delay
      await Future.delayed(const Duration(milliseconds: 400));

      // Update mock name locally (won't persist)
      _mockName = _nameController.text;
      final success = true; // Assume mock update always works

      if (mounted) {
         setState(() { _isLoading = false; });
         if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Perfil atualizado (mock)!'), backgroundColor: Colors.green),
            );
         } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Falha ao atualizar perfil (mock).'), backgroundColor: Colors.red),
            );
         }
      }
    }
  }

  Future<void> _logout() async {
    setState(() { _isLoading = true; });
    // Simulate logout delay
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
       // Navigate directly to login screen
       Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
    }
    // No need to set isLoading back to false as we are navigating away
  }

  @override
  Widget build(BuildContext context) {
    // Removed Provider Consumer
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil (Screens Only)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.account_circle, size: 100, color: Color(0xFF0A1D37)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o seu nome' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                // Use mock email
                initialValue: _mockEmail,
                enabled: false,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _updateName,
                      style: ElevatedButton.styleFrom(
                         minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Salvar Alterações'),
                    ),
              const Spacer(),
              TextButton.icon(
                onPressed: _isLoading ? null : _logout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sair da conta',
                    style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

