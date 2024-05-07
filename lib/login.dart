import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:codingmindsapp/sign-up.dart';
import 'main.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  int _counter = 0;
  late String _username;
  late String _password;
  late User? _user;
  FirebaseDatabase database = FirebaseDatabase.instance;

  void _login() {
    signIn(_username, _password);
  }

  void _goSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MySignUpPage(title: "Sign Up Page"))
    );
  }

  void signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      Navigator.pop(context);
      Navigator.pushReplacement( // Navigate to the home page
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: "Home Page")),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed to Sign In'),
            content: Text('Invalid username or password. \n Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      print("Failed to sign in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login to SchedulePlanner",
                style: TextStyle(
                  height: 3,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                onChanged: (String newEntry) {
                  print("Username was changed to $newEntry");
                  setState(() {
                    _username = newEntry;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                onChanged: (String newEntry) {
                  setState(() {
                    _password = newEntry;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: _goSignUp,
                child: const Text("Don't have a account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
