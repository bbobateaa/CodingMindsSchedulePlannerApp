import 'dart:ffi';
import 'package:codingmindsapp/new-entry-maker.dart';
import 'package:codingmindsapp/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';

class MyAddNewSchedulePage extends StatefulWidget {
  const MyAddNewSchedulePage({super.key, required this.title});

  final String title;

  @override
  State<MyAddNewSchedulePage> createState() => _MyAddNewSchedulePageState();
}

class _MyAddNewSchedulePageState extends State<MyAddNewSchedulePage> {
  int currentPageIndex = 1; // Set initial index to Add Entry page
  User? _user = FirebaseAuth.instance.currentUser;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  final TextEditingController _descriptionController = TextEditingController();
  List<ScheduleEntry> _scheduleEntries = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveScheduleEntry() {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      setState(() {
        ScheduleEntry scheduleEntry = ScheduleEntry(
          title: _titleController.text,
          dateTime: _selectedDateTime,
          description: _descriptionController.text,
        );
        _scheduleEntries.add(scheduleEntry);
        _titleController.clear();
        _descriptionController.clear();
        _selectedDateTime = DateTime.now();
      });
      pushScheduleToDatabase(_user!, _scheduleEntries.last); // Call the function with correct arguments
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Entry Saved Successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields.'),
      ));
    }
  }

  void pushScheduleToDatabase(User user, ScheduleEntry scheduleEntry) {
    String username = user.email ?? '';
    username = username.replaceAll(RegExp(r'[^\w\s]+'), '');
    final DatabaseReference scheduleRef = FirebaseDatabase.instance
        .reference()
        .child(username + "data");

    // Serialize scheduleEntry to JSON
    final Map<String, dynamic> scheduleJson = scheduleEntry.toJson();
    // Push data to the database
    scheduleRef.push().set(scheduleJson);
  }

  void _discardEntry() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedDateTime = DateTime.now();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Entry Discarded'),
    ));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          if (index != currentPageIndex) {
            setState(() {
              currentPageIndex = index;
            });
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage(title: "Home Page")),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyAddNewSchedulePage(title: "Add Page")),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MySettingsPage(title: "Setting Page")),
                );
                break;
            }
          };
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add Entry',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Schedule Planner"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Placeholder for action.'),
              ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Title',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
            ),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Enter title",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Date and Time',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () async {
                final DateTime? pickedDateTime = await showDatePicker(
                  context: context,
                  initialDate: _selectedDateTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDateTime != null) {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                    context: context,
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _selectedDateTime = DateTime(
                        pickedDateTime.year,
                        pickedDateTime.month,
                        pickedDateTime.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
              child: Text(
                _selectedDateTime.toString(),
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.purple),
              ),
            ),
            const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "Enter description",
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Adjust as needed
              children: [
                ElevatedButton(
                  onPressed: _saveScheduleEntry,
                  child: Text('Save Entry'),
                ),
                ElevatedButton(
                  onPressed: _discardEntry,
                  child: Text('Discard Entry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
