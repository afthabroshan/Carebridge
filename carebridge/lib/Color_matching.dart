// import 'dart:math';
// import 'package:flutter/material.dart';

// class ColorMatchingGame extends StatefulWidget {
//   const ColorMatchingGame({super.key});

//   @override
//   State<ColorMatchingGame> createState() => _ColorMatchingGameState();
// }

// class _ColorMatchingGameState extends State<ColorMatchingGame> {
//   final Map<Color, String> _colorNames = {
//     Colors.red: 'RED',
//     Colors.blue: 'BLUE',
//     Colors.green: 'GREEN',
//     Colors.yellow: 'YELLOW',
//     Colors.orange: 'ORANGE',
//     Colors.purple: 'PURPLE',
//     Colors.pink: 'PINK',
//     Colors.brown: 'BROWN',
//   };

//   late Color _targetColor;
//   late List<Color> _options;
//   String _feedback = '';

//   @override
//   void initState() {
//     super.initState();
//     _generateNewGame();
//   }

//   void _generateNewGame() {
//     _targetColor =
//         _colorNames.keys.elementAt(Random().nextInt(_colorNames.length));

//     // Ensure the target color is always in the options
//     List<Color> shuffledColors = List.of(_colorNames.keys)..shuffle();
//     _options =
//         shuffledColors.where((color) => color != _targetColor).take(3).toList();
//     _options.add(_targetColor);
//     _options.shuffle(); // Randomize the placement

//     _feedback = '';
//     setState(() {});
//   }

//   void _checkAnswer(Color selectedColor) {
//     setState(() {
//       _feedback =
//           (selectedColor == _targetColor) ? '✅ Correct!' : '❌ Try Again!';
//     });

//     if (selectedColor == _targetColor) {
//       Future.delayed(const Duration(seconds: 1), _generateNewGame);
//     }
//   }

//   /// Choose the best text color for contrast (black or white)
//   Color _getTextColor(Color bgColor) {
//     return (bgColor.computeLuminance() > 0.5) ? Colors.black : Colors.white;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Color Matching Game")),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text("Match the Color!", style: TextStyle(fontSize: 24)),
//           const SizedBox(height: 20),

//           // Display the target color
//           Container(
//             height: 100,
//             width: 100,
//             decoration: BoxDecoration(
//               color: _targetColor,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.black, width: 2),
//             ),
//           ),
//           const SizedBox(height: 20),

//           // Display multiple color choices
//           Wrap(
//             spacing: 15,
//             children: _options.map((color) {
//               return GestureDetector(
//                 onTap: () => _checkAnswer(color),
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 80,
//                       width: 80,
//                       margin: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: color,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.black, width: 2),
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       _colorNames[color]!,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black, // Ensures readability
//                       ),
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
import 'package:flutter/material.dart';

class ColorMatchingGame extends StatefulWidget {
  const ColorMatchingGame({super.key});

  @override
  State<ColorMatchingGame> createState() => _ColorMatchingGameState();
}

class _ColorMatchingGameState extends State<ColorMatchingGame> {
  final Map<Color, String> _colorNames = {
    Colors.red: 'RED',
    Colors.blue: 'BLUE',
    Colors.green: 'GREEN',
    Colors.yellow: 'YELLOW',
    Colors.orange: 'ORANGE',
    Colors.purple: 'PURPLE',
    Colors.pink: 'PINK',
    Colors.brown: 'BROWN',
  };

  late Color _targetColor;
  late List<Color> _options;
  String _feedback = '';
  int _score = 0; // Tracks score (out of 100)

  @override
  void initState() {
    super.initState();
    _generateNewGame();
  }

  void _generateNewGame() {
    _targetColor =
        _colorNames.keys.elementAt(Random().nextInt(_colorNames.length));

    // Ensure the target color is always in the options
    List<Color> shuffledColors = List.of(_colorNames.keys)..shuffle();
    _options =
        shuffledColors.where((color) => color != _targetColor).take(3).toList();
    _options.add(_targetColor);
    _options.shuffle(); // Randomize placement

    _feedback = '';
    setState(() {});
  }

  void _checkAnswer(Color selectedColor) {
    setState(() {
      if (selectedColor == _targetColor) {
        _feedback = '✅ Correct!';
        _score += 10; // ✅ Increase score by 10 points per correct answer

        // Reset game if score reaches 100
        if (_score >= 100) {
          Future.delayed(const Duration(seconds: 1), () {
            _score = 0; // Reset score
            _generateNewGame();
          });
        } else {
          Future.delayed(const Duration(seconds: 1), _generateNewGame);
        }
      } else {
        _feedback = '❌ Try Again!';
      }
    });
  }

  /// Choose the best text color for contrast (black or white)
  Color _getTextColor(Color bgColor) {
    return (bgColor.computeLuminance() > 0.5) ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Color Matching Game")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Match the Color!", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),

          // Display the target color
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: _targetColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
          const SizedBox(height: 20),

          // Progress Bar for Score
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _score / 100, // ✅ Progress bar updates dynamically
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue, // Bar color
                  borderRadius: BorderRadius.circular(5),
                ),
                const SizedBox(height: 8),
                Text(
                  "Score: $_score / 100",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Display multiple color choices
          Wrap(
            spacing: 15,
            children: _options.map((color) {
              return GestureDetector(
                onTap: () => _checkAnswer(color),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _colorNames[color]!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Ensures readability
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Feedback Message
          Text(
            _feedback,
            style: TextStyle(
              fontSize: 20,
              color: _feedback.contains('Correct') ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
