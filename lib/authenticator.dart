import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'Page1.dart';

class Authenticator extends StatefulWidget {
  const Authenticator({super.key});

  @override
  State<Authenticator> createState() => _AuthenticatorState();
}

class _AuthenticatorState extends State<Authenticator> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return const Page1();
        } else {
          return const LoginForm();
        }
      },
    );
  }
}