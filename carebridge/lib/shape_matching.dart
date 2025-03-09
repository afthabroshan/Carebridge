// import 'dart:math';
// import 'package:flutter/material.dart';

// class ShapeMatchingGame extends StatefulWidget {
//   const ShapeMatchingGame({super.key});

//   @override
//   State<ShapeMatchingGame> createState() => _ShapeMatchingGameState();
// }

// class _ShapeMatchingGameState extends State<ShapeMatchingGame> {
//   final List<Map<String, dynamic>> _shapeData = [
//     {'shape': 'Circle', 'icon': Icons.circle, 'color': Colors.blue},
//     {'shape': 'Square', 'icon': Icons.square, 'color': Colors.red},
//     {'shape': 'Triangle', 'icon': Icons.change_history, 'color': Colors.green},
//     {'shape': 'Star', 'icon': Icons.star, 'color': Colors.yellow},
//     {'shape': 'Heart', 'icon': Icons.favorite, 'color': Colors.pink},
//     {'shape': 'Diamond', 'icon': Icons.diamond, 'color': Colors.orange},
//   ];

//   late Map<String, dynamic> _targetShape;
//   late List<Map<String, dynamic>> _options;
//   String _feedback = '';

//   @override
//   void initState() {
//     super.initState();
//     _generateNewGame();
//   }

//   void _generateNewGame() {
//     _targetShape = _shapeData[Random().nextInt(_shapeData.length)];

//     // Ensure the target shape is always in the options
//     List<Map<String, dynamic>> shuffledShapes = List.of(_shapeData)..shuffle();
//     _options = shuffledShapes
//         .where((s) => s['shape'] != _targetShape['shape'])
//         .take(3)
//         .toList();
//     _options.add(_targetShape);
//     _options.shuffle(); // Randomize placement

//     _feedback = '';
//     setState(() {});
//   }

//   void _checkAnswer(Map<String, dynamic> selectedShape) {
//     setState(() {
//       _feedback = (selectedShape['shape'] == _targetShape['shape'])
//           ? '✅ Correct!'
//           : '❌ Try Again!';
//     });

//     if (selectedShape['shape'] == _targetShape['shape']) {
//       Future.delayed(const Duration(seconds: 1), _generateNewGame);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Shape Matching Game")),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text("Match the Shape!", style: TextStyle(fontSize: 24)),
//           const SizedBox(height: 20),

//           // Display Target Shape
//           Container(
//             height: 100,
//             width: 100,
//             // decoration: BoxDecoration(
//             //   color: Colors.black, //Colors.black
//             //   borderRadius: BorderRadius.circular(10),
//             // ),
//             child: Icon(_targetShape['icon'],
//                 size: 80, color: _targetShape['color']),
//           ),
//           const SizedBox(height: 20),

//           // Display Shape Choices
//           Wrap(
//             spacing: 15,
//             children: _options.map((shapeData) {
//               return GestureDetector(
//                 onTap: () => _checkAnswer(shapeData),
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 80,
//                       width: 80,
//                       margin: const EdgeInsets.all(8),
//                       // decoration: BoxDecoration(
//                       //   color: Colors.black,
//                       //   borderRadius: BorderRadius.circular(10),
//                       // ),
//                       child: Icon(shapeData['icon'],
//                           size: 60, color: shapeData['color']),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       shapeData['shape'],
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 20),

//           // Feedback Message
//           Text(
//             _feedback,
//             style: TextStyle(
//               fontSize: 20,
//               color: _feedback.contains('Correct') ? Colors.green : Colors.red,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:math';
import 'package:carebridge/db_helper.dart';
import 'package:flutter/material.dart';

class ShapeMatchingGame extends StatefulWidget {
  final int userId;

  const ShapeMatchingGame({super.key, required this.userId});

  @override
  State<ShapeMatchingGame> createState() => _ShapeMatchingGameState();
}

class _ShapeMatchingGameState extends State<ShapeMatchingGame> {
  final List<Map<String, dynamic>> _shapeData = [
    {'shape': 'Circle', 'icon': Icons.circle, 'color': Colors.blue},
    {'shape': 'Square', 'icon': Icons.square, 'color': Colors.red},
    {'shape': 'Triangle', 'icon': Icons.change_history, 'color': Colors.green},
    {'shape': 'Star', 'icon': Icons.star, 'color': Colors.yellow},
    {'shape': 'Heart', 'icon': Icons.favorite, 'color': Colors.pink},
    {'shape': 'Diamond', 'icon': Icons.diamond, 'color': Colors.orange},
  ];

  late Map<String, dynamic> _targetShape;
  late List<Map<String, dynamic>> _options;
  String _feedback = '';
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _generateNewGame();
  }

  Future<void> _updateScore(int newScore) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateScore(widget.userId, "Shape Matching", newScore);
    setState(() {
      _score = newScore;
    });
  }

  void _generateNewGame() {
    _targetShape = _shapeData[Random().nextInt(_shapeData.length)];
    List<Map<String, dynamic>> shuffledShapes = List.of(_shapeData)..shuffle();
    _options = shuffledShapes
        .where((s) => s['shape'] != _targetShape['shape'])
        .take(3)
        .toList();
    _options.add(_targetShape);
    _options.shuffle();

    _feedback = '';
    setState(() {});
  }

  void _checkAnswer(Map<String, dynamic> selectedShape) {
    setState(() {
      if (selectedShape['shape'] == _targetShape['shape']) {
        _feedback = '✅ Correct!';
        int newScore = (_score + 10).clamp(0, 100); // Ensure max is 100
        _updateScore(newScore);
        Future.delayed(const Duration(seconds: 1), _generateNewGame);
      } else {
        _feedback = '❌ Try Again!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shape Matching Game")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Match the Shape!", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 10),

          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _score / 100, // Normalize score between 0 and 1
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                  minHeight: 10,
                ),
                const SizedBox(height: 10),
                Text("Score: $_score / 100",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            height: 100,
            width: 100,
            child: Icon(_targetShape['icon'],
                size: 80, color: _targetShape['color']),
          ),
          const SizedBox(height: 20),

          Wrap(
            spacing: 15,
            children: _options.map((shapeData) {
              return GestureDetector(
                onTap: () => _checkAnswer(shapeData),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      margin: const EdgeInsets.all(8),
                      child: Icon(shapeData['icon'],
                          size: 60, color: shapeData['color']),
                    ),
                    const SizedBox(height: 5),
                    Text(shapeData['shape'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          Text(
            _feedback,
            style: TextStyle(
                fontSize: 20,
                color:
                    _feedback.contains('Correct') ? Colors.green : Colors.red),
          ),
        ],
      ),
    );
  }
}
