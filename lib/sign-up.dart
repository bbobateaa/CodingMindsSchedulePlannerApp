import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login.dart';

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  late String _username;
  late String _password;
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  void _signup() {
    signUp(_username, _password);

  }


  void signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      databaseReference.child('users').push().set({
        'email': _username,
        'password': _password,
      }).then((value) {
        print("Account made successfully");
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyLoginPage(title: "Login Page")),
        );
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed to Sign Up'),
            content: Text('Email taken or invalid auth \n Please try again.'),
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
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign Up Here",
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
              onPressed: _signup,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
