// import 'dart:math';
import 'dart:developer' as lg;
import 'dart:math';

import 'package:carebridge/userid.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ColorMatchingGame extends StatefulWidget {
  const ColorMatchingGame({super.key});

  @override
  State<ColorMatchingGame> createState() => _ColorMatchingGameState();
}

class _ColorMatchingGameState extends State<ColorMatchingGame> {
  final supabase = Supabase.instance.client;
  final loggedInUserId = UserSession().getUserId();
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
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _generateNewGame();
  }

  void _generateNewGame() {
    _targetColor =
        _colorNames.keys.elementAt(Random().nextInt(_colorNames.length));

    List<Color> shuffledColors = List.of(_colorNames.keys)..shuffle();
    _options =
        shuffledColors.where((color) => color != _targetColor).take(3).toList();
    _options.add(_targetColor);
    _options.shuffle();

    _feedback = '';
    setState(() {});
  }

  Future<void> _saveScore() async {
    try {
      final response = await supabase.from('scores').upsert({
        'user_id': loggedInUserId,
        'colors': _score,
      }, onConflict: 'user_id');
      lg.log("success");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Score saved successfully!')),
      );
    } catch (e) {
      lg.log(e.toString());
    }
  }

  void _checkAnswer(Color selectedColor) {
    setState(() {
      if (selectedColor == _targetColor) {
        _feedback = '✅ Correct!';
        _score += 10;

        if (_score >= 100) {
          Future.delayed(const Duration(seconds: 1), () {
            _score = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Color Matching Game"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.shade100, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Match the Color!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Target Color Display
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: _targetColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 3),
                ),
              ),
              const SizedBox(height: 30),

              // Progress Bar
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _score / 100,
                      minHeight: 15,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Score: $_score / 100",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Color Options in Card Layout
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: _options.map((color) {
                  return GestureDetector(
                    onTap: () => _checkAnswer(color),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                      elevation: 5,
                      child: Container(
                        width: 120,
                        height: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          _colorNames[color]!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),

              // Feedback Message
              Text(
                _feedback,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color:
                      _feedback.contains('Correct') ? Colors.green : Colors.red,
                ),
              ),
              ElevatedButton(
                onPressed: _saveScore,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  backgroundColor: Colors.blue,
                ),
                child: const Text("Save Score"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
