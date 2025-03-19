// import 'dart:math';

// import 'package:carebridge/db_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// class SpeechTherapy extends StatefulWidget {
//   const SpeechTherapy({super.key});

//   @override
//   State<SpeechTherapy> createState() => _SpeechTherapyState();
// }

// class _SpeechTherapyState extends State<SpeechTherapy> {
//   SpeechToText speechToText = SpeechToText();
//   bool speechEnabled = false;
//   String recognizedWord = '';
//   int score = 0;
//   int currentWordIndex = 0;
//   final Random _random = Random();

//   // List of words for different levels
//   List<String> wordList = [
//     'Water',
//     'Apple',
//     'Happy',
//     'Elephant',
//     'Friend',
//     'Sunshine',
//     'Guitar',
//     'Laptop',
//     'Dinosaur',
//     'Rainbow',
//     'Butterfly',
//     'Chocolate',
//     'Galaxy',
//     'Pencil',
//     'Mountain',
//     'Football',
//     'Telescope',
//     'Kangaroo',
//     'Strawberry',
//     'Library',
//     'Helicopter',
//     'Adventure',
//     'Candle',
//     'Bicycle',
//     'Telephone',
//     'Puzzle',
//     'Treasure',
//     'Parrot',
//     'Rocket',
//     'Painting',
//     'Cupcake',
//     'Pineapple'
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//     _shuffleWords();
//   }

//   @override
//   void dispose() {
//     Navigator.pop(context, score); // Return score to HomePage
//     super.dispose();
//   }

//   void _shuffleWords() {
//     wordList.shuffle(_random);
//   }

//   /// Initialize speech recognition
//   void _initSpeech() async {
//     speechEnabled = await speechToText.initialize();
//     setState(() {});
//   }

//   /// Start listening for speech input
//   void _startListening() async {
//     recognizedWord = ''; // Reset previous word
//     await speechToText.listen(
//       onResult: _onSpeechResult,
//       listenFor: const Duration(seconds: 3), // Listen for 3 seconds
//     );
//     setState(() {});
//   }

//   /// Stop listening and check result
//   void _stopListening() async {
//     await speechToText.stop();
//     _compareWords();
//     setState(() {});
//   }

//   /// Capture speech result
//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       recognizedWord = result.recognizedWords;
//     });
//   }

//   /// Compare recognized word with target word
//   void _compareWords() async {
//     String targetWord = wordList[currentWordIndex];

//     if (recognizedWord.toLowerCase().trim() ==
//         targetWord.toLowerCase().trim()) {
//       setState(() {
//         score += 10; // Increase score
//         currentWordIndex = (currentWordIndex + 1) % wordList.length;
//       });

//       int userId = 1; // Replace this with the actual logged-in user ID

//       // ✅ Update the database with the new Speech Therapy score
//       await DatabaseHelper.instance
//           .updateScore(userId, "Speech Therapy", score);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String targetWord = wordList[currentWordIndex];

//     return Scaffold(
//       appBar: AppBar(title: const Text("Speech Therapy")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Score: $score",
//                 style:
//                     const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             LinearProgressIndicator(
//               value: score / 100, // Normalize score between 0 and 1
//               backgroundColor: Colors.grey[300],
//               color: Colors.blue,
//               minHeight: 10,
//             ),
//             const SizedBox(height: 20),
//             Text("Say: $targetWord",
//                 style:
//                     const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _startListening();
//                 Future.delayed(
//                     const Duration(seconds: 3), () => _stopListening());
//               },
//               child: const Text("Start Listening"),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               "You said: $recognizedWord",
//               style: TextStyle(
//                   fontSize: 20,
//                   color: recognizedWord.isNotEmpty
//                       ? Colors.blueAccent
//                       : Colors.black),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'dart:developer' as lg;
import 'package:carebridge/userid.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SpeechTherapy extends StatefulWidget {
  const SpeechTherapy({super.key});

  @override
  State<SpeechTherapy> createState() => _SpeechTherapyState();
}

class _SpeechTherapyState extends State<SpeechTherapy> {
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  bool isListening = false; // ✅ Track listening state
  String recognizedWord = '';
  int score = 0;
  int currentWordIndex = 0;
  final Random _random = Random();
  final supabase = Supabase.instance.client;
  final loggedInUserId = UserSession().getUserId();

  List<String> wordList = [
    'Water',
    'Apple',
    'Happy',
    'Elephant',
    'Friend',
    'Sunshine',
    'Guitar',
    'Laptop',
    'Dinosaur',
    'Rainbow',
    'Butterfly',
    'Chocolate',
    'Galaxy',
    'Pencil',
    'Mountain',
    'Football',
    'Telescope',
    'Kangaroo',
    'Strawberry',
    'Library',
    'Helicopter',
    'Adventure',
    'Candle',
    'Bicycle',
    'Telephone',
    'Puzzle',
    'Treasure',
    'Parrot',
    'Rocket',
    'Painting',
    'Cupcake',
    'Pineapple'
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _shuffleWords();
  }

  @override
  void dispose() {
    Navigator.pop(context, score);
    super.dispose();
  }

  void _shuffleWords() {
    wordList.shuffle(_random);
  }

  void _initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    setState(() {
      recognizedWord = '';
      isListening = true; // ✅ Show loading state
    });

    await speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 3),
    );

    Future.delayed(const Duration(seconds: 3), () {
      _stopListening();
    });
  }

  Future<void> _saveScore() async {
    try {
      final response = await supabase.from('scores').upsert({
        'user_id': loggedInUserId,
        'speech': score,
      }, onConflict: 'user_id');
      lg.log("success");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Score saved successfully!')),
      );
    } catch (e) {
      lg.log(e.toString());
    }
  }

  void _stopListening() async {
    await speechToText.stop();
    _compareWords();

    setState(() {
      isListening = false; // ✅ Remove loading state
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      recognizedWord = result.recognizedWords;
    });
  }

  void _compareWords() async {
    String targetWord = wordList[currentWordIndex];

    if (recognizedWord.toLowerCase().trim() ==
        targetWord.toLowerCase().trim()) {
      setState(() {
        score += 10;
        currentWordIndex = (currentWordIndex + 1) % wordList.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String targetWord = wordList[currentWordIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech Therapy"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text("Score",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("$score",
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: score / 100,
                  minHeight: 12,
                  backgroundColor: Colors.grey[300],
                  color: Colors.greenAccent,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text("Say this word:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(targetWord,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 🎤 Start Listening Button with Loading Indicator
            ElevatedButton(
              onPressed: isListening
                  ? null
                  : _startListening, // Disable button while listening
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: isListening
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("Listening...", style: TextStyle(fontSize: 18)),
                      ],
                    )
                  : const Text("Start Listening",
                      style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 30),

            Text(
              "You said: $recognizedWord",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: recognizedWord.isNotEmpty
                      ? Colors.blueAccent
                      : Colors.black),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: _saveScore,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                backgroundColor: Colors.blue,
              ),
              child: const Text("Save Score"),
            ),
          ],
        ),
      ),
    );
  }
}
