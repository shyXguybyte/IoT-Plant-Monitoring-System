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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCFUFBlYu_noGr_7idXtWxjNuWJloNBQow',
    appId: '1:758222106739:web:dc35b9326e5f58702c7a06',
    messagingSenderId: '758222106739',
    projectId: 'myplantfirebase',
    authDomain: 'myplantfirebase.firebaseapp.com',
    storageBucket: 'myplantfirebase.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAizX-iJZjNxjF8If3iwU0tOv8Quq1GmZM',
    appId: '1:758222106739:android:dbd0b03845d2cf8a2c7a06',
    messagingSenderId: '758222106739',
    projectId: 'myplantfirebase',
    storageBucket: 'myplantfirebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgSNvsMcuahGqaS2-st8gQ0jLHl8ARibE',
    appId: '1:758222106739:ios:ed976c872f70976c2c7a06',
    messagingSenderId: '758222106739',
    projectId: 'myplantfirebase',
    storageBucket: 'myplantfirebase.appspot.com',
    iosBundleId: 'com.example.myPlant',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgSNvsMcuahGqaS2-st8gQ0jLHl8ARibE',
    appId: '1:758222106739:ios:ed976c872f70976c2c7a06',
    messagingSenderId: '758222106739',
    projectId: 'myplantfirebase',
    storageBucket: 'myplantfirebase.appspot.com',
    iosBundleId: 'com.example.myPlant',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCFUFBlYu_noGr_7idXtWxjNuWJloNBQow',
    appId: '1:758222106739:web:d50d81e08cb050882c7a06',
    messagingSenderId: '758222106739',
    projectId: 'myplantfirebase',
    authDomain: 'myplantfirebase.firebaseapp.com',
    storageBucket: 'myplantfirebase.appspot.com',
  );

}