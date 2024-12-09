import 'dart:core';

import 'package:flutter/material.dart';
import 'package:home_function/Colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Appointment> _appointments = [
    Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 2)),
      subject: 'Test Event',
      color: Colors.green,
    ),
    Appointment(
      startTime: DateTime.now().add(Duration(hours: 2)),
      endTime: DateTime.now().add(Duration(hours: 4)),
      subject: 'Test Event 2',
      color: const Color.fromARGB(255, 86, 76, 175),
    ),
  ];

  void _addAppointment(Appointment appointment) {
    setState(() {
      _appointments.add(appointment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newAppointment = await showDialog<Appointment>(
                context: context,
                builder: (context) => AddAppointmentDialog(),
              );
              if (newAppointment != null) {
                _addAppointment(newAppointment);
              }
            },
          ),
        ],
      ),
      body: SfCalendar(
        allowViewNavigation: false,
        view: CalendarView.week,
        firstDayOfWeek: 6,
        dataSource: MeetingDataSource(_appointments),
        appointmentTextStyle: const TextStyle(
          fontSize: 7,
          color: Colors.white,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

enum WeekDays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

int WeekDaysAsnum = [
  DateTime.now(),
  DateTime.now() as int,
  DateTime.wednesday,
  DateTime.thursday,
  DateTime.friday,
  DateTime.saturday,
  DateTime.sunday
] as int;

class AddAppointmentDialog extends StatefulWidget {
  @override
  State<AddAppointmentDialog> createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final _titleController = TextEditingController();
  final _startHourController = TextEditingController();
  final _startMinuteController = TextEditingController(); // NEW: For minutes
  final _durationController = TextEditingController();
  DateTime _selectedDay = DateTime(2024, 12, 8);
  Color _selectedColor = electricBlue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New Event"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: "Title"),
            ),
            // Replaced the dropdown for WeekDays with a Date Picker Button
            TextButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDay,
                  firstDate: DateTime(2024), // Start range for date selection
                  lastDate: DateTime(2025), // End range for date selection
                );
                if (selectedDate != null) {
                  setState(() {
                    _selectedDay = selectedDate;
                  });
                }
              },
              child: Text(
                "Selected Date: ${_selectedDay.toLocal().toString().split(' ')[0]}",
              ),
              iconAlignment: IconAlignment.start,
            ),
            TextField(
              controller: _startHourController,
              decoration: InputDecoration(hintText: "Start Hour (0-23)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _startMinuteController, // NEW: For minute input
              decoration: InputDecoration(hintText: "Start Minute (0-59)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(hintText: "Duration (hours)"),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<Color>(
              value: _selectedColor,
              items: [
                DropdownMenuItem(
                  value: electricBlue,
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: electricBlue),
                      SizedBox(width: 8),
                      Text('Electric Blue'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: teaGreen,
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: teaGreen),
                      SizedBox(width: 8),
                      Text('Tea Green'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: cream,
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: cream),
                      SizedBox(width: 8),
                      Text('Cream'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: sunset,
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: sunset),
                      SizedBox(width: 8),
                      Text('Sunset'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: melon,
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: melon),
                      SizedBox(width: 8),
                      Text('Melon'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedColor = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text;
            final startHour = int.tryParse(_startHourController.text) ?? 0;
            final startMinute = int.tryParse(_startMinuteController.text) ?? 0;
            final duration = int.tryParse(_durationController.text) ?? 1;
            // Check if the title is empty
            if (title.isEmpty) {
              // Show an error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Event title cannot be empty."),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            final startTime = DateTime(
              _selectedDay.year,
              _selectedDay.month,
              _selectedDay.day,
              startHour,
              startMinute,
            );
            final endTime = startTime.add(Duration(hours: duration));

            final appointment = Appointment(
              startTime: startTime,
              endTime: endTime,
              subject: title,
              color: _selectedColor,
            );

            Navigator.pop(context, appointment);
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
