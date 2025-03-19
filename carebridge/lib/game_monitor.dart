// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:carebridge/userid.dart';

// class GameMonitor extends StatefulWidget {
//   const GameMonitor({super.key});

//   @override
//   State<GameMonitor> createState() => _GameMonitorState();
// }

// class _GameMonitorState extends State<GameMonitor> {
//   double speechScore = 0.0;
//   double shapeScore = 0.0;
//   double colorsScore = 0.0;
//   double tracingScore = 0.0;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchHealthData();
//   }

//   Future<void> fetchHealthData() async {
//     final loggedInUserId = UserSession().getUserId();
//     final supabase = Supabase.instance.client;
//     try {
//       final response = await supabase
//           .from("scores")
//           .select("*")
//           .eq("user_id", loggedInUserId!);

//       if (response.isNotEmpty) {
//         final data = response.first;
//         setState(() {
//           speechScore = (double.tryParse(data["speech"].toString()) ?? 0) / 100;
//           shapeScore = (double.tryParse(data["shape"].toString()) ?? 0) / 100;
//           colorsScore = (double.tryParse(data["colors"].toString()) ?? 0) / 100;
//           tracingScore = (double.tryParse(data["tracing"].toString()) ?? 0) / 100;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       log("Error fetching data: ${e.toString()}");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text("Game Monitor",
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.blue.shade900,
//         elevation: 0,
//       ),
//       body: Center(
//         child: isLoading
//             ? const CircularProgressIndicator()
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Your Performance Overview",
//                     style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87),
//                   ),
//                   const SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         buildStatCard("Speech Therapy", speechScore, Colors.blueAccent),
//                         buildStatCard("Shape Matching", shapeScore, Colors.green),
//                         buildStatCard("Color Matching", colorsScore, Colors.redAccent),
//                         buildStatCard("Tracing Shape", colorsScore, Colors.redAccent),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget buildStatCard(String title, double percentage, Color color) {
//     return Container(
//       width: 120,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               blurRadius: 6,
//               spreadRadius: 3),
//         ],
//       ),
//       child: Column(
//         children: [
//           CircularPercentIndicator(
//             radius: 50.0,
//             lineWidth: 8.0,
//             percent: percentage.clamp(0.0, 1.0),
//             center: Text(
//               "${(percentage * 100).toInt()}%",
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             progressColor: color,
//             backgroundColor: Colors.grey.shade300,
//             circularStrokeCap: CircularStrokeCap.round,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             title,
//             style: TextStyle(
//                 fontSize: 16, fontWeight: FontWeight.bold, color: color),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:carebridge/userid.dart';

class GameMonitor extends StatefulWidget {
  const GameMonitor({super.key});

  @override
  State<GameMonitor> createState() => _GameMonitorState();
}

class _GameMonitorState extends State<GameMonitor> {
  double speechScore = 0.0;
  double shapeScore = 0.0;
  double colorsScore = 0.0;
  double tracingScore = 0.0;
  bool isLoading = true;
  bool hasData = false; // Track if user has scores

  @override
  void initState() {
    super.initState();
    fetchHealthData();
  }

  Future<void> fetchHealthData() async {
    final loggedInUserId = UserSession().getUserId();
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from("scores")
          .select("*")
          .eq("user_id", loggedInUserId!);

      if (response.isNotEmpty) {
        final data = response.first;
        setState(() {
          speechScore = (double.tryParse(data["speech"].toString()) ?? 0) / 100;
          shapeScore = (double.tryParse(data["shape"].toString()) ?? 0) / 100;
          colorsScore = (double.tryParse(data["colors"].toString()) ?? 0) / 100;
          tracingScore =
              (double.tryParse(data["tracing"].toString()) ?? 0) / 100;
          hasData = true;
        });
      } else {
        hasData = false;
      }
    } catch (e) {
      log("Error fetching data: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        title: const Text("Game Monitor",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : hasData
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Your Performance Overview",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildStatCard("Speech Therapy", speechScore,
                                Colors.blueAccent),
                            buildStatCard(
                                "Shape Matching", shapeScore, Colors.green),
                            buildStatCard("Color Matching", colorsScore,
                                Colors.redAccent),
                            buildStatCard(
                                "Tracing Shape", tracingScore, Colors.purple),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "No scores to display. \nPlay games to see the score",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
      ),
    );
  }

  Widget buildStatCard(String title, double percentage, Color color) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 3),
        ],
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 8.0,
            percent: percentage.clamp(0.0, 1.0),
            center: Text(
              "${(percentage * 100).toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            progressColor: color,
            backgroundColor: Colors.grey.shade300,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
