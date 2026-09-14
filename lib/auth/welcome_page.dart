import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final String name;
  final String email;
  final String uid;
  final String docId;

  const WelcomePage({super.key, required this.name, required this.email, required this.uid, required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 100, color: Colors.green),
              const SizedBox(height: 20),
              const Text('Successfully Connected to Firebase', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 30),
              const Text('Signed as:', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 10),
              Text(email, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              const Text('From firestore', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 20),
              Text(uid, style: const TextStyle(fontSize: 16, fontFamily: 'monospace'), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Text(name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // ✅ Just pop this page to reveal the Login screen underneath
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: const Text('CONTINUE TO LOGIN', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}