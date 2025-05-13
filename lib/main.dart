import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'tela_boas_vindas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {

  const MeuApp({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão Financeira Pessoal',
      home: const TelaBoasVindas(),
    );
  }
}
