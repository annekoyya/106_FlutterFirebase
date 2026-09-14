import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errormessage = '';
  bool isError = false;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> checkLogin() async {
    setState(() {
      isLoading = true;
      isError = false;
      errormessage = '';
    });

    if (usernameController.text.trim().isEmpty) {
      setState(() {
        errormessage = "Please input your username!";
        isError = true;
        isLoading = false;
      });
      return;
    } else if (passwordController.text.trim().isEmpty) {
      setState(() {
        errormessage = "Please input your password!";
        isError = true;
        isLoading = false;
      });
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );
      
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        isError = true;
        isLoading = false;
        if (e.code == 'user-not-found') {
          errormessage = 'No user found for that email';
        } else if (e.code == 'wrong-password') {
          errormessage = 'Wrong password provided';
        } else {
          errormessage = e.message ?? 'Login failed';
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errormessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'TIKITOKTOK',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Password',
                  prefixIcon: Icon(Icons.password),
                ),
              ),
              const SizedBox(height: 15),
              if (isError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    errormessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : checkLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}