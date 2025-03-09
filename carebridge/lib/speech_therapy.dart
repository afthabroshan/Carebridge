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
//   String words = '';
//   bool speechEnabled = false;
//   String targetWord = "Water";
//   String feedbackMessage = "";
//   void stt() {}

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   void _initSpeech() async {
//     speechEnabled = await speechToText.initialize();
//     setState(() {});
//   }

//   void _startListening() async {
//     await speechToText.listen(onResult: onspeechresult);
//     setState(() {});
//   }

//   void _stopListening() async {
//     await speechToText.stop();
//     setState(() {});
//   }

//   void onspeechresult(SpeechRecognitionResult result) {
//     setState(() {
//       words = result.recognizedWords;
//     });
//   }

//   void _checkSpeechMatch() {
//     if (words.toLowerCase().trim() == targetWord.toLowerCase().trim()) {
//       setState(() {
//         feedbackMessage = "✅ Correct! Well done!";
//       });
//     } else {
//       setState(() {
//         feedbackMessage = "❌ Try again! You said: '$words'";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Speech Therapy")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Let's try some speech therapy",
//                 style: TextStyle(fontSize: 18)),
//             const SizedBox(height: 40),
//             Text("Say: \"$targetWord\"",
//                 style:
//                     const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _startListening,
//               child: const Text("Start Listening"),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _stopListening,
//               child: const Text("Stop Listening"),
//             ),
//             const SizedBox(height: 20),
//             Text("You said: $words",
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _checkSpeechMatch,
//               child: const Text("Check"),
//             ),
//             const SizedBox(height: 20),
//             Text(feedbackMessage,
//                 style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue)),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
//   String targetWord = 'Water';
//   String resultMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   /// Initialize speech recognition
//   void _initSpeech() async {
//     speechEnabled = await speechToText.initialize();
//     setState(() {});
//   }

//   /// Start listening for speech input
//   void _startListening() async {
//     resultMessage = ''; // Clear previous result
//     recognizedWord = '';

//     await speechToText.listen(
//       onResult: _onSpeechResult,
//       listenFor: const Duration(seconds: 3), // Listen for 3 seconds
//       onSoundLevelChange: (level) {}, // Optional: Track sound levels
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
//   void _compareWords() {
//     if (recognizedWord.toLowerCase().trim() ==
//         targetWord.toLowerCase().trim()) {
//       setState(() {
//         resultMessage = '✅ Correct!';
//       });
//     } else {
//       setState(() {
//         resultMessage = '❌ Incorrect! You said: "$recognizedWord"';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Speech Therapy")),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Center(
//               child: Text("Let's try some speech therapy",
//                   style: TextStyle(fontSize: 18))),
//           const SizedBox(height: 40),
//           Text("Say: $targetWord",
//               style:
//                   const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               _startListening();
//               Future.delayed(
//                   const Duration(seconds: 3), () => _stopListening());
//             },
//             child: const Text("Start Listening"),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             resultMessage,
//             style: TextStyle(
//                 fontSize: 20,
//                 color: resultMessage.contains('Correct')
//                     ? Colors.green
//                     : Colors.red),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:carebridge/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechTherapy extends StatefulWidget {
  const SpeechTherapy({super.key});

  @override
  State<SpeechTherapy> createState() => _SpeechTherapyState();
}

class _SpeechTherapyState extends State<SpeechTherapy> {
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String recognizedWord = '';
  int score = 0;
  int currentWordIndex = 0;
  final Random _random = Random();

  // List of words for different levels
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
    Navigator.pop(context, score); // Return score to HomePage
    super.dispose();
  }

  void _shuffleWords() {
    wordList.shuffle(_random);
  }

  /// Initialize speech recognition
  void _initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  /// Start listening for speech input
  void _startListening() async {
    recognizedWord = ''; // Reset previous word
    await speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 3), // Listen for 3 seconds
    );
    setState(() {});
  }

  /// Stop listening and check result
  void _stopListening() async {
    await speechToText.stop();
    _compareWords();
    setState(() {});
  }

  /// Capture speech result
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      recognizedWord = result.recognizedWords;
    });
  }

  /// Compare recognized word with target word
  void _compareWords() async {
    String targetWord = wordList[currentWordIndex];

    if (recognizedWord.toLowerCase().trim() ==
        targetWord.toLowerCase().trim()) {
      setState(() {
        score += 10; // Increase score
        currentWordIndex = (currentWordIndex + 1) % wordList.length;
      });

      int userId = 1; // Replace this with the actual logged-in user ID

      // ✅ Update the database with the new Speech Therapy score
      await DatabaseHelper.instance
          .updateScore(userId, "Speech Therapy", score);
    }
  }

  @override
  Widget build(BuildContext context) {
    String targetWord = wordList[currentWordIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Speech Therapy")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Score: $score",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            LinearProgressIndicator(
              value: score / 100, // Normalize score between 0 and 1
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 10,
            ),
            const SizedBox(height: 20),
            Text("Say: $targetWord",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _startListening();
                Future.delayed(
                    const Duration(seconds: 3), () => _stopListening());
              },
              child: const Text("Start Listening"),
            ),
            const SizedBox(height: 20),
            Text(
              "You said: $recognizedWord",
              style: TextStyle(
                  fontSize: 20,
                  color: recognizedWord.isNotEmpty
                      ? Colors.blueAccent
                      : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
