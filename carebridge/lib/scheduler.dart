import 'package:carebridge/main.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class DailySchedulerPage extends StatefulWidget {
  const DailySchedulerPage({super.key});

  @override
  State<DailySchedulerPage> createState() => _DailySchedulerPageState();
}

class _DailySchedulerPageState extends State<DailySchedulerPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<String>> _events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Scheduler")),
      body: Column(
        children: [
          TableCalendar(
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
                      children:
                          List.generate(events.length.clamp(1, 3), (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
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
          const SizedBox(height: 10),
          Expanded(
            child: _events[_selectedDate] == null ||
                    _events[_selectedDate]!.isEmpty
                ? const Center(child: Text("No events yet!"))
                : ListView.builder(
                    itemCount: _events[_selectedDate]!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_events[_selectedDate]![index]),
                        leading: const Icon(Icons.event),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEventDialog() {
    TextEditingController eventController = TextEditingController();
    DateTime? startDateTime;
    DateTime? endDateTime;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Event"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Select Start Date & Time
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

              // Select End Date & Time
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

              // Enter Event Name
              TextField(
                controller: eventController,
                decoration: const InputDecoration(labelText: "Event Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (eventController.text.isNotEmpty &&
                    startDateTime != null &&
                    endDateTime != null) {
                  setState(() {
                    _events[_selectedDate] ??= [];
                    _events[_selectedDate]!.add(
                        "${eventController.text} (From: ${startDateTime.toString()} to ${endDateTime.toString()})");
                  });

                  // ✅ Schedule notification at startDateTime
                  _scheduleNotification(
                      eventController.text, startDateTime!, endDateTime!);

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

// Schedule a notification for the event
  Future<void> _scheduleNotification(
      String eventName, DateTime startDateTime, DateTime endDateTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Unique ID
      "Upcoming Event",
      "$eventName\nStart: ${startDateTime.toString()}\nEnd: ${endDateTime.toString()}",
      tz.TZDateTime.from(startDateTime, tz.local), // Schedule at start time
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'event_channel', // Channel ID
          'Event Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
