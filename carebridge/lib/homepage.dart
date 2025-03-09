import 'package:carebridge/Color_matching.dart';
import 'package:carebridge/db_helper.dart';
import 'package:carebridge/loginpage.dart';
import 'package:carebridge/scheduler.dart';
import 'package:carebridge/shape_matching.dart';
import 'package:carebridge/speech_therapy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/src/flutter_local_notifications_plugin.dart';
import 'usermodel.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  void speechtherapy(BuildContext context) async {
    final int? newScore = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SpeechTherapy()),
    );

    if (newScore != null) {
      user.speechTherapyScore += newScore; // Update the user's score
    }
  }

  void emotiontherapy(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ColorMatchingGame()));
  }

  void memoryandmatchinggames(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShapeMatchingGame(
                  userId: 1,
                )));
  }

  void dailyscheduler(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DailySchedulerPage()));
  }

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
                            "Your score is only ${user.speechTherapyScore}, play more and achieve more."),
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
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  featureCard("Games", "assets/games.png", () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Choose a Game",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                gameTile(
                                  context,
                                  "Speech Therapy",
                                  // 10,
                                  user.speechTherapyScore,
                                  () => speechtherapy(context),
                                ),
                                gameTile(
                                  context,
                                  "Color Matching",
                                  10,
                                  // user.emotionTherapyScore,
                                  () => emotiontherapy(context),
                                ),
                                // gameTile(
                                //   context,
                                //   "Emotion Therapy",
                                //   user.emotionTherapyScore,
                                //   () async {
                                //     int newScore = await playGame("Emotion Therapy");
                                //     await DatabaseHelper.instance.updateScore(user.id!, "Emotion Therapy", newScore);
                                //     setState(() => user.emotionTherapyScore = newScore);
                                //   },
                                // ),
                                gameTile(
                                  context,
                                  "Shape Matching",
                                  1,
                                  // user.shapeMatchingScore,
                                  () => memoryandmatchinggames(context),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  featureCard("Daily Schedule", "assets/calendar.png", () {
                    dailyscheduler(context);
                  }),
                  featureCard("Growth Monitor", "assets/growth.png", () {}),
                  featureCard("Community Forum", "assets/community.png", () {}),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     Container(
            //       height: MediaQuery.of(context).size.width / 2 - 25,
            //       width: MediaQuery.of(context).size.width / 2 - 25,
            //       color: const Color.fromARGB(255, 132, 132, 132),
            //       child: TextButton(
            //           onPressed: () {
            //             speechtherapy(context);
            //           },
            //           child: Text("Games")),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Container(
            //       height: MediaQuery.of(context).size.width / 2 - 25,
            //       width: MediaQuery.of(context).size.width / 2 - 25,
            //       color: const Color.fromARGB(255, 132, 132, 132),
            //       child: TextButton(
            //           onPressed: () {
            //             speechtherapy(context);
            //           },
            //           child: Text("Daily Schedules")),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 10),
            // Row(
            //   children: [
            //     Container(
            //       height: MediaQuery.of(context).size.width / 2 - 25,
            //       width: MediaQuery.of(context).size.width / 2 - 25,
            //       color: const Color.fromARGB(255, 132, 132, 132),
            //       child: TextButton(
            //           onPressed: () {
            //             speechtherapy(context);
            //           },
            //           child: Text("Speech therapy")),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Container(
            //       height: MediaQuery.of(context).size.width / 2 - 25,
            //       width: MediaQuery.of(context).size.width / 2 - 25,
            //       color: const Color.fromARGB(255, 132, 132, 132),
            //     ),
            //   ],
            // )
            //     Container(
            //       width: MediaQuery.of(context).size.width,
            //       // color: Colors.brown,
            //       decoration: BoxDecoration(
            //           color: Colors.grey,
            //           shape: BoxShape.rectangle,
            //           borderRadius: BorderRadius.all(Radius.circular(25))),
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           children: [
            //             Row(
            //               children: [
            //                 Text("Progress:"),
            //                 SizedBox(width: 10),
            //                 Expanded(
            //                   child: LinearProgressIndicator(
            //                     value: 0,
            //                     // value: user.score / 100,
            //                     color: Colors.black,
            //                     // semanticsValue: "0",
            //                   ),
            //                 )
            //               ],
            //             ),
            //             Text("0")
            //           ],
            //         ),
            //       ),
            //     ),
            //     SizedBox(height: 10),
            //     Container(
            //       width: MediaQuery.of(context).size.width,
            //       decoration: BoxDecoration(
            //           color: Colors.lightBlue,
            //           shape: BoxShape.rectangle,
            //           borderRadius: BorderRadius.all(Radius.circular(25))),
            //       // color: Colors.blueGrey,
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           children: [
            //             Row(
            //               children: [
            //                 Text("Points:"),
            //                 SizedBox(width: 10),
            //                 Expanded(
            //                   child: LinearProgressIndicator(
            //                     value: user.score / 100,
            //                     color: Colors.brown,
            //                     backgroundColor: Colors.grey,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             Text("${user.score}")
            //           ],
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       height: 10,
            //     ),
            //     Container(
            //         height: 100,
            //         width: MediaQuery.of(context).size.width,
            //         color: Colors.lightGreen,
            //         child: Column(children: [
            //           Text("Games"),
            //           SizedBox(
            //             height: 10,
            //           ),
            //           Row(
            //             children: [
            //               TextButton(
            //                   onPressed: () {
            //                     speechtherapy(context);
            //                   },
            //                   child: Text("Speech therapy")),
            //               TextButton(
            //                   onPressed: () {
            //                     emotiontherapy(context);
            //                   },
            //                   child: Text("Emotion therapy")),
            //               TextButton(
            //                   onPressed: () {
            //                     memoryandmatchinggames(context);
            //                   },
            //                   child: Text("Shape Matching")),
            //             ],
            //           ),
            //         ])),
            //     TextButton(
            //         onPressed: () {
            //           dailyscheduler(context);
            //         },
            //         child: Text("Daily scheduler")),
          ],
        ),
      ),
    );
  }

  Widget gameTile(
      BuildContext context, String gameName, int userId, Function onTap) {
    return FutureBuilder<int>(
      future: getGameScore(userId, gameName), // Fetch the latest score
      builder: (context, snapshot) {
        int score = snapshot.data ?? 0; // Use retrieved score or default to 0

        return GestureDetector(
          onTap: () => onTap(), // Call the game function when tapped
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  gameName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    //   Text(
                    //     "Score: $score",
                    //     style: const TextStyle(
                    //         fontSize: 16, fontWeight: FontWeight.w500),
                    //   ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// A function to retrieve the score dynamically
  Future<int> getGameScore(int userId, String game) async {
    // final dbHelper = DatabaseHelper.instance;
    // final user = await dbHelper.getUser(); // Fetch user data

    // if (user == null) return 0; // Return 0 if no user found

    if (game == "Speech Therapy") {
      return user.speechTherapyScore;
    } else if (game == "Emotion Therapy") {
      return user.emotionTherapyScore;
    } else if (game == "Shape Matching") {
      return user.shapeMatchingScore;
    }
    return 0; // Default case
  }

  Widget featureCard(String title, String iconPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 50),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
