import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qrventory/screens/login_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const QRventoryApp());
}

class QRventoryApp extends StatelessWidget {
  const QRventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRventory',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          secondary: Colors.amber,
          brightness: Brightness.light,
        ),
      ),
      home: SafeArea(child: LoginScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}

