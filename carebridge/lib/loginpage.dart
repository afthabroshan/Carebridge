import 'package:carebridge/signuppage.dart';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'usermodel.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await DatabaseHelper.instance.getUser(email, password);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: user)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email or password!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email")),
            TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true),
            ElevatedButton(onPressed: login, child: Text("Login")),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
