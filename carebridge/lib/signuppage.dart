import 'dart:developer';
import 'package:carebridge/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  void registerUser() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showSnackBar("Please fill all fields");
      return;
    }
    setState(() => isLoading = true);
    try {
      await supabase.from('user_details').insert({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
        'age': ageController.text.trim(),
        'diagnosis': diagnosisController.text.trim()
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyLogin()),
      );
    } catch (e) {
      log(e.toString());
      showSnackBar("Error: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // _buildBackground(),
          _buildRegisterForm(),
        ],
      ),
    );
  }

  // Widget _buildBackground() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         image: AssetImage('assets/register.png'),
  //         fit: BoxFit.cover,
  //         colorFilter:
  //             ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            SizedBox(height: 40),
            _buildTextField(nameController, "Name"),
            SizedBox(height: 20),
            _buildTextField(emailController, "Email"),
            SizedBox(height: 20),
            _buildTextField(passwordController, "Password", isPassword: true),
            SizedBox(height: 20),
            _buildTextField(ageController, "Age"),
            SizedBox(height: 20),
            _buildTextField(diagnosisController, "Diagnosis"),
            SizedBox(height: 40),
            _buildSignUpButton(),
            SizedBox(height: 30),
            _buildSignInOption(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Account',
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          'Start your Care Bridge journey today!',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: isLoading ? null : registerUser,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4c505b), Colors.white10],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildSignInOption() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyLogin())),
        child: Text(
          'Already have an account? Sign In',
          style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.white70,
              fontSize: 16),
        ),
      ),
    );
  }
}
