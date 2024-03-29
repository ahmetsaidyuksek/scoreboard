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
    apiKey: 'AIzaSyAs2TR7SLmEQ4p2YLstQZZRll1CfBeDXuI',
    appId: '1:654709961899:android:6fd63076026802c15373ee',
    messagingSenderId: '654709961899',
    projectId: 'scoreboard-30678',
    databaseURL: 'https://scoreboard-30678-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'scoreboard-30678.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOAxAfxjnKK1C0WGGq-IAFfp4MYG1eAs0',
    appId: '1:654709961899:ios:1ffe7d69178e2e345373ee',
    messagingSenderId: '654709961899',
    projectId: 'scoreboard-30678',
    databaseURL: 'https://scoreboard-30678-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'scoreboard-30678.appspot.com',
    iosClientId: '654709961899-0ajl3uf79k8f4e9dql51unieik3uvte0.apps.googleusercontent.com',
    iosBundleId: 'com.example.scoreboard',
  );
}
