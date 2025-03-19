import 'package:carebridge/game_monitor.dart';
import 'package:carebridge/health_monitor.dart';
import 'package:carebridge/homepage.dart';
import 'package:carebridge/loginpage.dart';
import 'package:carebridge/shape_tracing.dart';
import 'package:carebridge/vaccine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Initialize Notifications Plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // tz.initializeTimeZones();

  // // Android Notification Settings
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');

  // const InitializationSettings initializationSettings =
  //     InitializationSettings(android: initializationSettingsAndroid);

  // // Initialize Notifications
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qtzxbwphrvpmwpiadeuz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF0enhid3BocnZwbXdwaWFkZXV6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE5MzEzMjEsImV4cCI6MjA1NzUwNzMyMX0.JVDFZMhGCOcPJQ_i12D2t3ctgLrQRdAqOEryk9MUjvc',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyLogin(),
      // home: HomePage(),
      // home: GameMonitor()
      //   user: User(
      //     name: "af",
      //     email: "af",
      //     password: "af",
      //     age: 21,
      //     diagnosis: "amnesia",
      //     speechTherapyScore: 0,
      //   ),
      // ),
    );
  }
}
