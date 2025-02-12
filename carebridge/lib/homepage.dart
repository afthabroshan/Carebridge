import 'package:carebridge/loginpage.dart';
import 'package:flutter/material.dart';
import 'usermodel.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user.name}"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${user.name}", style: TextStyle(fontSize: 18)),
            Text("Email: ${user.email}", style: TextStyle(fontSize: 18)),
            Text("Age: ${user.age}", style: TextStyle(fontSize: 18)),
            Text("Diagnosis: ${user.diagnosis}",
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
