 import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdm_tp2/tela_boas_vindas.dart' show TelaBoasVindas;
import 'tela_cadastro.dart';

class TelaLogin extends StatefulWidget {
const TelaLogin({super.key});
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final Color corFundo = const Color(0xFF0A1D37);
  final Color corPrincipal = Colors.white;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;


    try {
      UserCredential userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

  if (userCredential.user != null) {
        // Usando a chave global do ScaffoldMessenger
        _mostrarSnackBar(
            context,
            const SnackBar(content: Text('Login realizado com sucesso'))
        );

      }
      // await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: email,
      //   password: senha,
      // );
      //
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Login realizado com sucesso')),
      //   );
      // }

    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.message}')),
        );
      }
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }


  }
  void _mostrarSnackBar(BuildContext context, SnackBar snackBar) {
    final scaffold = ScaffoldMessenger.maybeOf(context);
    if (scaffold != null && mounted) {
      scaffold.showSnackBar(snackBar);
    } else {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _campoTexto(label: 'Email', controller: _emailController),
            const SizedBox(height: 16),
            _campoTexto(label: 'Senha', isSenha: true, controller: _senhaController),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Esqueceu sua senha?', style: TextStyle(color: corPrincipal)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrincipal,
                  foregroundColor: corFundo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _login,
                child: const Text('Entrar'),
              ),
            ),
            const SizedBox(height: 16),
            Center(child: Text('ou', style: TextStyle(color: corPrincipal))),
            const SizedBox(height: 16),
            _botaoSocial(
              icone: Icons.g_mobiledata,
              texto: 'Continuar com Google',
              corTexto: corFundo,
              corFundo: corPrincipal,
              onPressed: () {}, // login com google
            ),
            const SizedBox(height: 12),
            _botaoSocial(
              icone: Icons.facebook,
              texto: 'Continuar com Facebook',
              corTexto: corFundo,
              corFundo: corPrincipal,
              onPressed: () {}, // login com facebook
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaCadastro()),
                  );
                },
                child: const Text(
                  'Ainda não tem conta? Cadastre-se',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _campoTexto({
    required String label,
    required TextEditingController controller,
    bool isSenha = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isSenha,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white38),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: isSenha ? const Icon(Icons.visibility, color: Colors.white70) : null,
      ),
    );
  }

  Widget _botaoSocial({
    required IconData icone,
    required String texto,
    required Color corTexto,
    required Color corFundo,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: corFundo,
          foregroundColor: corTexto,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icone),
        label: Text(texto),
      ),
    );
  }
}
