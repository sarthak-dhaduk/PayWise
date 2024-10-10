import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:paywise/screens/LoginPage.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const PayWise());
}

class PayWise extends StatefulWidget {
  const PayWise({super.key});

  @override
  State<PayWise> createState() => _PayWiseState();
}

class _PayWiseState extends State<PayWise> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  );
  }
}