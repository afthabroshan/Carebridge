import 'package:carebridge/forum_images.dart';
import 'package:carebridge/game_monitor.dart';
import 'package:carebridge/health_monitor.dart';
import 'package:carebridge/shape_tracing.dart';
import 'package:carebridge/userid.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:carebridge/Color_matching.dart';
import 'package:carebridge/db_helper.dart';
import 'package:carebridge/loginpage.dart';
import 'package:carebridge/scheduler.dart';
import 'package:carebridge/shape_matching.dart';
import 'package:carebridge/speech_therapy.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final loggedInUserId = UserSession().getUserId();
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final response = await supabase
        .from('user_details')
        .select('*')
        .eq('id', loggedInUserId!)
        .maybeSingle();
    setState(() {
      userDetails = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: const Text(
          "Welcome back to Care Bridge",
          style: TextStyle(color: Colors.blueGrey),
        ),
        backgroundColor: Colors.blueGrey.shade900,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MyLogin()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            userDetails == null
                ? const CircularProgressIndicator()
                : userInfoCard(userDetails!),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  featureCard("Games", "assets/games.png", () {
                    showGameSelection(context);
                  }),
                  featureCard("Daily Schedule", "assets/calendar.png", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DailySchedulerPage()));
                  }),
                  featureCard("Growth Monitor", "assets/growth.png", () {
                    showGrowthMonitorSelection(context);
                  }),
                  featureCard("Community Forum", "assets/community.png", () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ForumImages()));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userInfoCard(Map<String, dynamic> user) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name: ${user['name']}", style: cardTextStyle()),
          Text("Email: ${user['email']}", style: cardTextStyle()),
          Text("Age: ${user['age']}", style: cardTextStyle()),
          Text("Diagnosis: ${user['diagnosis']}", style: cardTextStyle()),
        ],
      ),
    );
  }

  Widget featureCard(String title, String iconPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.shade100, Colors.blueAccent.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Ensure text is visible
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gameTile(String gameName, Function onTap) {
    return ListTile(
      title: Text(gameName, style: cardTextStyle()),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: () => onTap(),
    );
  }

  void showGameSelection(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.blueGrey.shade800,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Choose a Game", style: cardTextStyle()),
              const SizedBox(height: 10),
              gameTile("Language", () => navigateToGame(SpeechTherapy())),
              gameTile("Cognitive", () => handleCognitiveSelection(context)),
              gameTile("Sensory", () => navigateToGame(ShapeTracingGame())),
            ],
          ),
        );
      },
    );
  }

  /// Handles Cognitive Selection based on User Preference
  void handleCognitiveSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose Your Cognitive Game"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Color Matching"),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  navigateToGame(ColorMatchingGame());
                },
              ),
              ListTile(
                title: const Text("Shape Matching"),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  navigateToGame(ShapeMatchingGame());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showGrowthMonitorSelection(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.blueGrey.shade800,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Choose the Growth Monitor", style: cardTextStyle()),
              const SizedBox(height: 10),
              gameTile("Health Monitoring",
                  () => navigateToMonitor(HealthMonitor())),
              gameTile(
                  "Games Monitoring", () => navigateToMonitor(GameMonitor())),
            ],
          ),
        );
      },
    );
  }

  void navigateToMonitor(Widget montior) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => montior));
  }

  void navigateToGame(Widget game) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => game));
  }

  TextStyle cardTextStyle() {
    return const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
  }
}
