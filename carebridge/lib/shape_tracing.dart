import 'dart:developer' as lg;
import 'dart:math';

import 'package:carebridge/userid.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runApp(const MaterialApp(home: ShapeTracingGame()));
}

class ShapeTracingGame extends StatefulWidget {
  const ShapeTracingGame({super.key});

  @override
  _ShapeTracingGameState createState() => _ShapeTracingGameState();
}

class _ShapeTracingGameState extends State<ShapeTracingGame> {
  List<Offset> userPath = [];
  List<Offset> expectedPath = [];
  String selectedShape = "Circle";
  int score = 0;
  double progress = 0.0;
  final ConfettiController _confettiController =
      ConfettiController(duration: Duration(seconds: 2));
  final supabase = Supabase.instance.client;
  final loggedInUserId = UserSession().getUserId(); // Default shape

  @override
  void initState() {
    super.initState();
    generateExpectedPath(); // Generate initial shape
  }

  void generateExpectedPath() {
    expectedPath.clear();
    const double size = 120;
    const Offset center = Offset(200, 300);

    switch (selectedShape) {
      case "Circle":
        generateCirclePath(center, size);
        break;
      case "Square":
        generateSquarePath(center, size);
        break;
      case "Triangle":
        generateTrianglePath(center, size);
        break;
      case "Star":
        generateStarPath(center, size);
        break;
    }

    setState(() {}); // Refresh UI
  }

  void generateCirclePath(Offset center, double radius) {
    const int points = 50;
    for (int i = 0; i < points; i++) {
      double angle = (2 * pi * i) / points;
      expectedPath.add(Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      ));
    }
  }

  void generateSquarePath(Offset center, double size) {
    double halfSize = size / 2;

    expectedPath.clear();

    // Generate points along the edges
    int steps = 20;
    for (int i = 0; i <= steps; i++) {
      double t = i / steps;
      expectedPath.add(Offset(
          center.dx - halfSize + size * t, center.dy - halfSize)); // Top edge
    }
    for (int i = 0; i <= steps; i++) {
      double t = i / steps;
      expectedPath.add(Offset(
          center.dx + halfSize, center.dy - halfSize + size * t)); // Right edge
    }
    for (int i = 0; i <= steps; i++) {
      double t = i / steps;
      expectedPath.add(Offset(center.dx + halfSize - size * t,
          center.dy + halfSize)); // Bottom edge
    }
    for (int i = 0; i <= steps; i++) {
      double t = i / steps;
      expectedPath.add(Offset(
          center.dx - halfSize, center.dy + halfSize - size * t)); // Left edge
    }
  }

  void generateTrianglePath(Offset center, double size) {
    double height = sqrt(3) / 2 * size;
    Offset p1 = Offset(center.dx, center.dy - height / 2);
    Offset p2 = Offset(center.dx - size / 2, center.dy + height / 2);
    Offset p3 = Offset(center.dx + size / 2, center.dy + height / 2);

    expectedPath.clear();

    int steps = 20;
    for (int i = 0; i <= steps; i++) {
      double t = i / steps;
      expectedPath.add(Offset(
          p1.dx + (p2.dx - p1.dx) * t, p1.dy + (p2.dy - p1.dy) * t)); // Side 1
    }
    for (int i = 0; i <= steps; i++) {
      double t = i / steps;
      expectedPath.add(Offset(
          p2.dx + (p3.dx - p2.dx) * t, p2.dy + (p3.dy - p2.dy) * t)); // Side 2
    }
    for (int i = 0; i <= steps; i++) {
      double t = i / steps;
      expectedPath.add(Offset(
          p3.dx + (p1.dx - p3.dx) * t, p3.dy + (p1.dy - p3.dy) * t)); // Side 3
    }
  }

  void generateStarPath(Offset center, double size) {
    const int points = 10;
    for (int i = 0; i < points; i++) {
      double angle = pi / 2 + (2 * pi * i) / points;
      double radius = (i.isEven) ? size / 2 : size;
      expectedPath.add(Offset(
        center.dx + radius * cos(angle),
        center.dy - radius * sin(angle),
      ));
    }
    expectedPath.add(expectedPath.first); // Close the star shape
  }

  bool isTracingCorrect() {
    if (userPath.length < expectedPath.length * 0.6) return false;

    int matchCount = 0;
    Set<int> coveredEdges = {};
    double threshold = 15; // Reduce threshold for better matching

    // Define expected edges based on shape
    int totalEdges;
    switch (selectedShape) {
      case "Triangle":
        totalEdges = 3;
        break;
      case "Square":
        totalEdges = 4;
        break;
      case "Star":
        totalEdges = 10;
        break;
      default:
        totalEdges = 10; // Circle approximation
    }

    for (var userPoint in userPath) {
      for (int i = 0; i < expectedPath.length; i++) {
        if ((userPoint - expectedPath[i]).distance < threshold) {
          matchCount++;
          coveredEdges.add(i ~/
              (expectedPath.length ~/ totalEdges)); // Ensure full edge coverage
          break;
        }
      }
    }

    double accuracy = matchCount / expectedPath.length;
    lg.log("Accuracy: $accuracy");
    lg.log("Covered Edges: ${coveredEdges.length} / $totalEdges");

    return accuracy > 0.6 && coveredEdges.length >= totalEdges;
  }

  void checkSuccess() {
    if (isTracingCorrect()) {
      _confettiController.play(); // 🎉 Show Confetti
      setState(() {
        score += 10; // ✅ Increase score
        progress = 1.0; // ✅ Mark progress as complete
      });

      showDialog(
        context: context,
        barrierDismissible: false, // Prevent accidental dismissal
        builder: (context) => AlertDialog(
          title: const Text("Great Job! 🎉"),
          content: Text("You traced the $selectedShape correctly!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                moveToNextShape(); // ✅ Move to next shape
              },
              child: const Text("Next Shape"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Oops! ❌"),
          content: Text("Try tracing the $selectedShape again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  userPath.clear(); // ✅ Clear user path for retry
                  progress = 0.0; // ✅ Reset progress
                });
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _saveScore() async {
    try {
      final response = await supabase.from('scores').upsert({
        'user_id': loggedInUserId,
        'tracing': score,
      }, onConflict: 'user_id');
      lg.log("success");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Score saved successfully!')),
      );
    } catch (e) {
      lg.log(e.toString());
    }
  }

  /// Moves to the next shape in the list
  void moveToNextShape() {
    List<String> shapes = ["Circle", "Square", "Triangle", "Star"];
    int currentIndex = shapes.indexOf(selectedShape);

    setState(() {
      selectedShape =
          shapes[(currentIndex + 1) % shapes.length]; // ✅ Cycle to next shape
      userPath.clear();
      progress = 0.0;
      generateExpectedPath(); // ✅ Update expected path
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shape Tracing Game")),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade300],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildDropdown(),
                ),
                _buildScoreDisplay(),
                Text(
                  "Start from the green and follow the arrow!",
                  style: TextStyle(
                    fontSize: 12, // Bigger text for readability
                    fontWeight: FontWeight.bold, // Bold for emphasis
                    color: Colors.green.shade900, // A deep blue for contrast
                    letterSpacing: 1.2, // Slight spacing for style
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        userPath.add(details.localPosition);
                        progress = userPath.length / expectedPath.length;
                      });
                    },
                    onPanEnd: (details) {
                      checkSuccess();
                    },
                    child: _buildDrawingCanvas(),
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveScore,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("Save Score"),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 2,
              emissionFrequency: 0.1,
              numberOfParticles: 20,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
      child: DropdownButton<String>(
        value: selectedShape,
        isExpanded: true,
        underline: SizedBox(),
        items: ["Circle", "Square", "Triangle", "Star"]
            .map((shape) => DropdownMenuItem(
                  value: shape,
                  child: Text(shape, style: TextStyle(fontSize: 16)),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedShape = value;
              userPath.clear();
              progress = 0.0;
              generateExpectedPath();
            });
          }
        },
      ),
    );
  }

  Widget _buildScoreDisplay() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.yellow.shade700, size: 30),
            SizedBox(width: 8),
            Text("Score: $score",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawingCanvas() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: ShapePainter(userPath, expectedPath),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final List<Offset> userPath;
  final List<Offset> expectedPath;

  ShapePainter(this.userPath, this.expectedPath);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outlinePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    Paint tracePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    Paint arrowPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    Paint startPointPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    // Draw expected shape outline
    Path path = Path();
    if (expectedPath.isNotEmpty) {
      path.moveTo(expectedPath.first.dx, expectedPath.first.dy);
      for (var point in expectedPath.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      path.close();
    }
    canvas.drawPath(path, outlinePaint);

    // Draw user trace
    if (userPath.length > 1) {
      for (int i = 0; i < userPath.length - 1; i++) {
        canvas.drawLine(userPath[i], userPath[i + 1], tracePaint);
      }
    }

    // Draw arrows for guidance
    drawArrows(canvas, expectedPath, arrowPaint);

    // Draw the green starting point
    if (expectedPath.isNotEmpty) {
      canvas.drawCircle(expectedPath.first, 10, startPointPaint);
    }
  }

  void drawArrows(Canvas canvas, List<Offset> path, Paint paint) {
    if (path.length < 2) return;

    for (int i = 0; i < path.length - 1; i += max(1, path.length ~/ 5)) {
      Offset start = path[i];
      Offset end = path[i + 1];

      // Draw guiding arrow
      drawArrowhead(canvas, start, end, paint);
    }
  }

  void drawArrowhead(Canvas canvas, Offset start, Offset end, Paint paint) {
    const double arrowSize = 10;
    double angle = atan2(end.dy - start.dy, end.dx - start.dx);

    Offset arrow1 = Offset(
      end.dx - arrowSize * cos(angle - pi / 6),
      end.dy - arrowSize * sin(angle - pi / 6),
    );
    Offset arrow2 = Offset(
      end.dx - arrowSize * cos(angle + pi / 6),
      end.dy - arrowSize * sin(angle + pi / 6),
    );

    Path arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrow1.dx, arrow1.dy)
      ..lineTo(arrow2.dx, arrow2.dy)
      ..close();

    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
