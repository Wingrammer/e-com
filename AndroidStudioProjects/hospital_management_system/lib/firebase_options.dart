// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDoht8xOSRr3WsPUHx0_FOXBtj1Tig7-js',
    appId: '1:683350531210:web:e5766e1424b5a86538e173',
    messagingSenderId: '683350531210',
    projectId: 'chopeandcharity',
    authDomain: 'chopeandcharity.firebaseapp.com',
    storageBucket: 'chopeandcharity.appspot.com',
    measurementId: 'G-11QRP9FD4Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDj89xhY1j9u1ItgjwwD_dJp2saOxJb-VQ',
    appId: '1:683350531210:android:a6265018b822815538e173',
    messagingSenderId: '683350531210',
    projectId: 'chopeandcharity',
    storageBucket: 'chopeandcharity.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBHlnQEHMRBQ3oazM7eLzi-E590nWOcZk',
    appId: '1:683350531210:ios:34495ad023978f2d38e173',
    messagingSenderId: '683350531210',
    projectId: 'chopeandcharity',
    storageBucket: 'chopeandcharity.appspot.com',
    iosClientId: '683350531210-uqej5f0oeluk77mis7qsu96gr5h1hnc3.apps.googleusercontent.com',
    iosBundleId: 'com.kpioc.hospitalManagementSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCBHlnQEHMRBQ3oazM7eLzi-E590nWOcZk',
    appId: '1:683350531210:ios:34495ad023978f2d38e173',
    messagingSenderId: '683350531210',
    projectId: 'chopeandcharity',
    storageBucket: 'chopeandcharity.appspot.com',
    iosClientId: '683350531210-uqej5f0oeluk77mis7qsu96gr5h1hnc3.apps.googleusercontent.com',
    iosBundleId: 'com.kpioc.hospitalManagementSystem',
  );
}