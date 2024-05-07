// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0LwLWupdtcjk0VMKQjIbbg1LiY027ji0',
    appId: '1:513093706419:android:4410d83c91e1af975746c6',
    messagingSenderId: '513093706419',
    projectId: 'coding-minds-app-helen-chau',
    databaseURL: 'https://coding-minds-app-helen-chau-default-rtdb.firebaseio.com',
    storageBucket: 'coding-minds-app-helen-chau.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD98LxhzncDLlLNAW7CHIu80RioUDxBS8s',
    appId: '1:513093706419:ios:50e38b6cdf91c7d35746c6',
    messagingSenderId: '513093706419',
    projectId: 'coding-minds-app-helen-chau',
    databaseURL: 'https://coding-minds-app-helen-chau-default-rtdb.firebaseio.com',
    storageBucket: 'coding-minds-app-helen-chau.appspot.com',
    iosBundleId: 'com.example.codingmindsapp',
  );

}