import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_app/authentication/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD4PkkqTGxW1-k7vUhCi-nikUadRsC6Ju0",
          authDomain: "indriver-clone-fe705.firebaseapp.com",
          projectId: "indriver-clone-fe705",
          storageBucket: "indriver-clone-fe705.firebasestorage.app",
          messagingSenderId: "605110982985",
          appId: "1:605110982985:web:1d9aa9f9b74806ae18e298",
          measurementId: "G-14H4KVYYZE"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SignUpScreen(),
    );
  }
}
