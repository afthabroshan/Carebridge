import 'package:carebridge/loginpage.dart';
import 'package:flutter/material.dart';
import 'usermodel.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user.name}"),
        actions: [
          badges.Badge(
            badgeContent: Text("1"),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("You have 1 new notification"),
                        content: Text(
                            "Please do complete the tasks assigned for today"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.notifications)),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              // color: Colors.brown,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${user.name}", style: TextStyle(fontSize: 18)),
                    Text("Email: ${user.email}",
                        style: TextStyle(fontSize: 18)),
                    Text("Age: ${user.age}", style: TextStyle(fontSize: 18)),
                    Text("Diagnosis: ${user.diagnosis}",
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              // color: Colors.brown,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Progress:"),
                        SizedBox(width: 10),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: 0,
                            color: Colors.black,
                            // semanticsValue: "0",
                          ),
                        )
                      ],
                    ),
                    Text("0%")
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              // color: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Points:"),
                        SizedBox(width: 10),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: 0,
                            color: Colors.brown,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text("0")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
