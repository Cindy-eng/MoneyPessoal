import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pdm_tp2/views/dashboard/dashboard_screen.dart';
import 'package:pdm_tp2/views/screens/login/tela_login.dart';
import 'screens/login/tela_boas_vindas.dart';

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
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      routes: {
        '/DashboardScreen': (context) =>  DashboardScreen(),
        '/add_transaction': (context) => Placeholder(),
        '/budgets': (context) => Placeholder(),
        '/goals': (context) => Placeholder(),
        '/reminders': (context) => Placeholder(),
        '/reports': (context) => Placeholder(),
        '/profile': (context) => Placeholder(),
        '/login':(context)=>TelaBoasVindas()
      },
    );
  }
}
