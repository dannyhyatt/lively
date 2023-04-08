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
    apiKey: 'AIzaSyBW15isHxXKn1AQq4nQHR4z0s0iDJO19CE',
    appId: '1:798973706338:web:855d398fafc432d10b113b',
    messagingSenderId: '798973706338',
    projectId: 'lively-accef',
    authDomain: 'lively-accef.firebaseapp.com',
    storageBucket: 'lively-accef.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1hHPKs1gX1KB25YG83m92El-RvmtnoTc',
    appId: '1:798973706338:android:cbea5dd74a9148670b113b',
    messagingSenderId: '798973706338',
    projectId: 'lively-accef',
    storageBucket: 'lively-accef.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxrq3HydMieBUDM9svSdvE0dacU3tKXfM',
    appId: '1:798973706338:ios:c577022ffc858e2a0b113b',
    messagingSenderId: '798973706338',
    projectId: 'lively-accef',
    storageBucket: 'lively-accef.appspot.com',
    iosClientId:
        '798973706338-ncq4uiqhp0q47pul6rvcuv26r9vde7uk.apps.googleusercontent.com',
    iosBundleId: 'com.example.lively',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCxrq3HydMieBUDM9svSdvE0dacU3tKXfM',
    appId: '1:798973706338:ios:c577022ffc858e2a0b113b',
    messagingSenderId: '798973706338',
    projectId: 'lively-accef',
    storageBucket: 'lively-accef.appspot.com',
    iosClientId:
        '798973706338-ncq4uiqhp0q47pul6rvcuv26r9vde7uk.apps.googleusercontent.com',
    iosBundleId: 'com.example.lively',
  );
}
