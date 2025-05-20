import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdm_tp2/tela_boas_vindas.dart';
import 'tela_login.dart';
//distributionUrl=https\://services.gradle.org/distributions/gradle-8.10.2-all.zip
class TelaCadastro extends StatefulWidget {

  const TelaCadastro({
    super.key
});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final corFundo = const Color(0xFF0A1D37);
  final corPrincipal = Colors.white;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ValueNotifier<bool> _camposPreenchidos = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_verificarCampos);
    _emailController.addListener(_verificarCampos);
    _senhaController.addListener(_verificarCampos);
    _confirmaSenhaController.addListener(_verificarCampos);
  }

  void _verificarCampos() {
    final preenchidos = _usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _senhaController.text.isNotEmpty &&
        _confirmaSenhaController.text.isNotEmpty;
    _camposPreenchidos.value = preenchidos;
  }

  void _cadastrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final confirmaSenha = _confirmaSenhaController.text.trim();

    if (senha != confirmaSenha) {
      _mostrarMensagem('As senhas não coincidem!');
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _mostrarMensagem('Cadastro realizado com sucesso!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TelaLogin()),
      );

    } on FirebaseAuthException catch (e) {
      _mostrarMensagem(e.message ?? 'Erro ao cadastrar.');
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Cadastrar', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _campoTexto(label: 'Usuário', controller: _usernameController),
              const SizedBox(height: 16),
              _campoTexto(label: 'Email', controller: _emailController),
              const SizedBox(height: 16),
              _campoTexto(label: 'Senha', isSenha: true, controller: _senhaController),
              const SizedBox(height: 16),
              _campoTexto(label: 'Confirma senha', isSenha: true, controller: _confirmaSenhaController),
              const SizedBox(height: 24),
              ValueListenableBuilder<bool>(
                valueListenable: _camposPreenchidos,
                builder: (context, preenchido, _) {
                  return preenchido
                      ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corPrincipal,
                        foregroundColor: corFundo,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _cadastrar,
                      child: const Text('Cadastrar'),
                    ),
                  )
                      : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto({
    required String label,
    bool isSenha = false,
    required TextEditingController controller,
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
        suffixIcon: isSenha ? const Icon(Icons.lock, color: Colors.white70) : null,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    _camposPreenchidos.dispose();
    super.dispose();
  }
}