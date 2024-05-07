import 'package:codingmindsapp/add-new-schedule.dart';
import 'package:codingmindsapp/login.dart';
import 'package:codingmindsapp/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => MyLoginPage(title: "Login Page"),
        '/home': (context) => MyHomePage(title: "Home Page"),
      },
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  List<Map<String, String>> scheduleData = [];
  User? user = FirebaseAuth.instance.currentUser;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  @override
  void initState() {
    super.initState();
    fetchScheduleEntries();
  }

  void fetchScheduleEntries() async {
    String username = user?.email ?? '';
    username = username.replaceAll(RegExp(r'[^\w\s]+'), '');
    final ref = FirebaseDatabase.instance.reference().child(username + "data");
    final snapshot = await ref.get();
    if (snapshot.exists) {
      List<Map<String, String>> data = [];
      for (final schedule in snapshot.children) {
        data.add({
          "dateTime": schedule
              .child("dateTime")
              .value
              .toString(),
          "title": schedule
              .child("title")
              .value
              .toString(),
          "description": schedule
              .child("description")
              .value
              .toString(),
        });
        setState(() {
          scheduleData = data;
        });
      }
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text("Hello, ${user?.email ?? "User"}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: scheduleData.length,
              itemBuilder: (context, index) {
                final schedule = scheduleData[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  title: Text(
                    schedule["title"] ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.0),
                      Text(
                        schedule["dateTime"] ?? "",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        schedule["description"] ?? "",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle onTap event if needed
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyAddNewSchedulePage(
                title: "Add Page")),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}