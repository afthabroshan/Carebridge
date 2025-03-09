import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'usermodel.dart';
import 'loginpage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();

  void signUp() async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    int age = int.tryParse(ageController.text) ?? 0;
    String diagnosis = diagnosisController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        diagnosis.isEmpty ||
        age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields correctly.")),
      );
      return;
    }

    final user = User(
        name: name,
        email: email,
        password: password,
        age: age,
        diagnosis: diagnosis,
        speechTherapyScore: 0);
    await DatabaseHelper.instance.insertUser(user);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User registered! Please log in.")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name")),
            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email")),
            TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true),
            TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number),
            TextField(
                controller: diagnosisController,
                decoration: InputDecoration(labelText: "Diagnosis")),
            ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Already have an account? Sign in'),
            )
          ],
        ),
      ),
    );
  }
}
