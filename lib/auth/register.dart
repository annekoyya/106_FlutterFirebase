import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'welcome_page.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool isLoading = false;
  String errorMessage = '';

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // 1. Create Auth User (This automatically logs them in)
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. Add User Data to Firestore
      DocumentReference docRef = await _firestore.collection('Employee').add({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'uid': userCredential.user?.uid,
      });

      // ✅ 3. SIGN THEM OUT immediately so the Login screen works properly
      await _auth.signOut();

      if (!mounted) return;
      
      // 4. Go to Welcome Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            uid: userCredential.user!.uid,
            docId: docRef.id,
          ),
        ),
      );
      
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Registration failed';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
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
                'REGISTER',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(controller: nameController, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Enter Name', prefixIcon: Icon(Icons.person))),
              const SizedBox(height: 15),
              TextField(controller: emailController, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Enter Email', prefixIcon: Icon(Icons.email))),
              const SizedBox(height: 15),
              TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Enter Password', prefixIcon: Icon(Icons.password))),
              const SizedBox(height: 15),
              if (errorMessage.isNotEmpty) Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : registerUser,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('REGISTER', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Already have an account? Login'))
            ],
          ),
        ),
      ),
    );
  }
}