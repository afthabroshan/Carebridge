import 'dart:developer';

import 'package:carebridge/userid.dart';
import 'package:carebridge/vaccine.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthMonitor extends StatefulWidget {
  const HealthMonitor({super.key});

  @override
  _HealthMonitorState createState() => _HealthMonitorState();
}

class _HealthMonitorState extends State<HealthMonitor> {
  final supabase = Supabase.instance.client;
  final Map<String, List<Map<String, dynamic>>> healthData = {
    "Weight": [],
    "Height": [],
    "Head Circumference": [],
  };

  void _addData(String category) {
    DateTime selectedDate = DateTime.now();
    double value = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add $category Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Enter Value"),
                onChanged: (val) => value = double.tryParse(val) ?? 0.0,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (value > 0) {
                  await addHealthData(category, value, selectedDate);
                  setState(() {
                    healthData[category]?.add({
                      "date": selectedDate,
                      "value": value,
                    });
                    healthData[category]
                        ?.sort((a, b) => a["date"].compareTo(b["date"]));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> addHealthData(
      String category, double value, DateTime date) async {
    final loggedInUserId = UserSession().getUserId();
    try {
      final response = await supabase.from("health_data").insert({
        "user_id": loggedInUserId,
        "category": category,
        "value": value,
        "date": date.toIso8601String(),
      });
      log(response);
    } catch (e) {
      log("error form 97 $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchHealthData(String category) async {
    final loggedInUserId = UserSession().getUserId();
    try {
      final response = await supabase
          .from("health_data")
          .select("*")
          .eq("user_id", loggedInUserId!)
          .eq("category", category)
          .order("date", ascending: true);
      log(response.toString());
      return response.map<Map<String, dynamic>>((item) {
        return {
          "date": DateTime.parse(item["date"]),
          "value": double.tryParse(item["value"].toString()) ?? 0.0,
        };
      }).toList();
    } catch (e) {
      log("error of fetching data ${e.toString()}");
    }
    return [];
  }

  // Widget _buildHealthSection(String category, IconData icon) {
  //   return FutureBuilder<List<Map<String, dynamic>>>(
  //     future: fetchHealthData(category),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //       if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
  //         return const Center(child: Text("No data available"));
  //       }

  //       return Card(
  //         elevation: 4,
  //         margin: const EdgeInsets.symmetric(vertical: 10),
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //         child: Column(
  //           children: [
  //             ListTile(
  //               leading: Icon(icon, size: 40, color: Colors.blueAccent),
  //               title: Text(category,
  //                   style: const TextStyle(
  //                       fontSize: 18, fontWeight: FontWeight.bold)),
  //               trailing: IconButton(
  //                 icon: const Icon(Icons.add, color: Colors.blueAccent),
  //                 onPressed: () => _addData(category),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 200,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(10.0),
  //                 child: LineChart(_buildChartData(snapshot.data!)),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  Widget _buildHealthSection(String category, IconData icon) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchHealthData(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(icon, size: 40, color: Colors.blueAccent),
                  title: Text(category,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.add, color: Colors.blueAccent),
                    onPressed: () => _addData(category),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "No data available",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addData(category),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Data"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              ListTile(
                leading: Icon(icon, size: 40, color: Colors.blueAccent),
                title: Text(category,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.add, color: Colors.blueAccent),
                  onPressed: () => _addData(category),
                ),
              ),
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LineChart(_buildChartData(snapshot.data!)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVaccineSection(String category, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blueAccent),
        title: Text(category,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
        onTap: () {
          if (category == "Vaccination") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Vaccine()),
            );
          }
        },
      ),
    );
  }

  LineChartData _buildChartData(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return LineChartData();
    }

    // Convert dates to timestamps (days since epoch for better readability)
    List<FlSpot> spots = data.map((entry) {
      double xValue = entry["date"].millisecondsSinceEpoch.toDouble();
      double yValue = entry["value"];
      return FlSpot(xValue, yValue);
    }).toList();

    // Sort by date to ensure correct plotting
    spots.sort((a, b) => a.x.compareTo(b.x));

    log(spots.toString());

    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)), // Hides top values
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (spots.length > 1)
                ? (spots.last.x - spots.first.x) / 4
                : null, // Adjust intervals dynamically
            getTitlesWidget: (value, meta) {
              DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(value.toInt());
              return Text(DateFormat("MM/dd").format(date),
                  style: const TextStyle(fontSize: 10));
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        border: const Border(
          left: BorderSide(color: Colors.blue),
          bottom: BorderSide(color: Colors.blue),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          aboveBarData: BarAreaData(show: false),
          spots: spots,
          isCurved: true,
          color: Colors.blueAccent,
          dotData: FlDotData(show: true),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Monitoring"),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.blue.shade300],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildVaccineSection("Vaccination", Icons.vaccines),
                _buildHealthSection("Weight", Icons.monitor_weight),
                _buildHealthSection("Height", Icons.height),
                _buildHealthSection(
                    "Head Circumference", Icons.accessibility_new),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
