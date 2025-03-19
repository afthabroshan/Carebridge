import 'dart:developer';

import 'package:carebridge/userid.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class DailySchedulerPage extends StatefulWidget {
  const DailySchedulerPage({super.key});

  @override
  State<DailySchedulerPage> createState() => _DailySchedulerPageState();
}

class _DailySchedulerPageState extends State<DailySchedulerPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<String>> _events = {};
  // List<Map<String, dynamic>> _events = [];
  final supabase = Supabase.instance.client;
  final loggedInUserId = UserSession().getUserId();
  bool isLoading = true; // Initially, loading is true

  @override
  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Scheduler",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(12),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  focusedDay: _selectedDate,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                  },
                  eventLoader: (day) => _events[day] ?? [],
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          bottom: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(events.length.clamp(1, 3),
                                (index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _events.isEmpty
                      ? const Center(
                          child: Text(
                            "No events yet!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              _events.keys.length, // Iterate over all dates
                          itemBuilder: (context, index) {
                            DateTime dateKey =
                                _events.keys.elementAt(index); // Get date
                            List<String> events =
                                _events[dateKey] ?? []; // Get events

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Text(
                                    DateFormat("yyyy-MM-dd")
                                        .format(dateKey), // Print Date
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ...events.asMap().entries.map((entry) {
                                  int eventIndex = entry.key;
                                  String eventDetails = entry.value;

                                  RegExp regex =
                                      RegExp(r"(.+?) \(From: (.+?) to (.+?)\)");
                                  Match? match = regex.firstMatch(eventDetails);

                                  String eventName =
                                      match?.group(1) ?? eventDetails;
                                  String startDate =
                                      match != null ? match.group(2)! : "";
                                  String endDate =
                                      match != null ? match.group(3)! : "";

                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(10),
                                      title: Text(
                                        eventName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "$startDate - $endDate",
                                        style:
                                            TextStyle(color: Colors.grey[700]),
                                      ),
                                      leading: const Icon(Icons.event,
                                          color: Colors.deepPurple),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          await _deleteEvent(
                                              dateKey, eventIndex);
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(),
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Future<void> _deleteEvent(DateTime date, int index) async {
    // Remove from local map
    setState(() {
      _events[date]?.removeAt(index);
      if (_events[date]?.isEmpty ?? false) {
        _events.remove(date);
      }
    });
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase
          .from('events')
          .select('*')
          .eq("user_id", loggedInUserId!)
          .order('starting', ascending: true);
      log(response.toString());
      setState(() {
        _events.clear();
        for (var event in response) {
          DateTime date = DateTime.parse(event['starting']).toLocal();

          // Normalize to remove time (set hour, minute, second to zero)
          DateTime normalizedDate = DateTime(date.year, date.month, date.day);

          String title = event['event'];
          String formattedEvent =
              "$title (From: ${DateFormat('hh:mm a').format(date)} to ${DateFormat('hh:mm a').format(DateTime.parse(event['ending']).toLocal())})";

          _events[normalizedDate] ??= [];
          _events[normalizedDate]!.add(formattedEvent);
        }
        log(_events.toString());
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void _saveEvent(String title, DateTime start, DateTime end) async {
    try {
      await supabase.from('events').insert({
        'user_id': loggedInUserId,
        'event': title,
        'starting': start.toUtc().toIso8601String(),
        'ending': end.toUtc().toIso8601String(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date saved successfully!')),
      );
      fetchEvents();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some error occured!')),
      );
      log(e.toString());
    }
    // Refresh events after inserting
  }

  void _showAddEventDialog() {
    TextEditingController eventController = TextEditingController();
    DateTime? startDateTime;
    DateTime? endDateTime;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          title: const Text("Add Event",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(startDateTime == null
                    ? "Select Start Date & Time"
                    : "Start: ${startDateTime.toString()}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        startDateTime = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
              ),
              ListTile(
                title: Text(endDateTime == null
                    ? "Select End Date & Time"
                    : "End: ${endDateTime.toString()}"),
                trailing: const Icon(Icons.timer),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: startDateTime ?? _selectedDate,
                    firstDate: startDateTime ?? DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        endDateTime = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
              ),
              TextField(
                controller: eventController,
                decoration: const InputDecoration(labelText: "Event Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                if (eventController.text.isNotEmpty &&
                    startDateTime != null &&
                    endDateTime != null) {
                  _saveEvent(
                      eventController.text, startDateTime!, endDateTime!);
                  setState(() {
                    _events[_selectedDate] ??= [];
                    _events[_selectedDate]!.add(
                        "${eventController.text} (From: ${startDateTime.toString()} to ${endDateTime.toString()})");
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
