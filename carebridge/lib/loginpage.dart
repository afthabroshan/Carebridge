import 'dart:developer';
import 'package:carebridge/homepage.dart';
import 'package:carebridge/signuppage.dart';
import 'package:carebridge/userid.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool isChecked = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackground(),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2), // Light Blue
            Color(0xFF145DA0), // Darker Blue
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 250),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeText(),
            SizedBox(height: 40),
            _buildTextField(email, "Email"),
            SizedBox(height: 20),
            _buildTextField(password, "Password", isPassword: true),
            SizedBox(height: 30),
            _buildSignInButton(),
            SizedBox(height: 20),
            _buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back to',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        Text(
          'Care Bridge',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: isLoading ? null : login,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Color(0xff4c505b),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                'Sign In',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyRegister()),
        ),
        child: Text(
          'Sign Up',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 16,
            color: Color(0xff4c505b),
          ),
        ),
      ),
    );
  }

  void login() async {
    setState(() => isLoading = true);

    try {
      final response = await supabase
          .from('user_details')
          .select('password, id')
          .eq('email', email.text.trim())
          .maybeSingle();

      if (response == null) {
        showSnackBar("User not found. Please sign up.");
        return;
      }

      if (response['password'] != password.text.trim()) {
        showSnackBar("Invalid password. Please try again.");
        return;
      }

      UserSession().setUserId(response['id']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      log(e.toString());
      showSnackBar("An error occurred. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
