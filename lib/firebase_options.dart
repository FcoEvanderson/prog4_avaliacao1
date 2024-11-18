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
    apiKey: 'AIzaSyAYIZJEQ5kKRa_VPq0aqC6OZncUR7i7Bsk',
    appId: '1:536980204726:web:42233a889374f7a0194a17',
    messagingSenderId: '536980204726',
    projectId: 'mytasksapp-f2e3b',
    authDomain: 'mytasksapp-f2e3b.firebaseapp.com',
    storageBucket: 'mytasksapp-f2e3b.firebasestorage.app',
    measurementId: 'G-B11QDFL128',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkpebmqKi8r4eU5YCNgCAaYFMKpvAJxVA',
    appId: '1:536980204726:android:167436cb09ef0d37194a17',
    messagingSenderId: '536980204726',
    projectId: 'mytasksapp-f2e3b',
    storageBucket: 'mytasksapp-f2e3b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBYawyVgoElj0nLpxWXjoUd8qbMMz1YpQU',
    appId: '1:536980204726:ios:4de05bf2a7b0b3c5194a17',
    messagingSenderId: '536980204726',
    projectId: 'mytasksapp-f2e3b',
    storageBucket: 'mytasksapp-f2e3b.firebasestorage.app',
    iosBundleId: 'com.example.avaliacao1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBYawyVgoElj0nLpxWXjoUd8qbMMz1YpQU',
    appId: '1:536980204726:ios:4de05bf2a7b0b3c5194a17',
    messagingSenderId: '536980204726',
    projectId: 'mytasksapp-f2e3b',
    storageBucket: 'mytasksapp-f2e3b.firebasestorage.app',
    iosBundleId: 'com.example.avaliacao1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAYIZJEQ5kKRa_VPq0aqC6OZncUR7i7Bsk',
    appId: '1:536980204726:web:89291dc5b510004d194a17',
    messagingSenderId: '536980204726',
    projectId: 'mytasksapp-f2e3b',
    authDomain: 'mytasksapp-f2e3b.firebaseapp.com',
    storageBucket: 'mytasksapp-f2e3b.firebasestorage.app',
    measurementId: 'G-SD1WKN3FJG',
  );
}
