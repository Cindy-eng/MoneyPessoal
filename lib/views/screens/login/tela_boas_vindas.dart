import 'package:flutter/material.dart';
import 'tela_login.dart';

class TelaBoasVindas extends StatelessWidget {
  const TelaBoasVindas({super.key});

  @override
  Widget build(BuildContext context) {
    final corFundo = const Color(0xFF0A1D37);
    final corPrincipal = Colors.white;

    return Scaffold(
      backgroundColor: corFundo,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.wallet, size: 80, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Nosso app vai ajudar você a fazer uma melhor estão do seu dinheiro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrincipal,
                  foregroundColor: corFundo,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaLogin()),
                  );
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
