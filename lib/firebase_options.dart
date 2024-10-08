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
    apiKey: 'AIzaSyBmXg4ZeEzk_R650yMpmEHkp5Mm20kJvmA',
    appId: '1:614806614589:web:289a4b48162705a9fd3054',
    messagingSenderId: '614806614589',
    projectId: 'paywise-0220',
    authDomain: 'paywise-0220.firebaseapp.com',
    storageBucket: 'paywise-0220.appspot.com',
    measurementId: 'G-DL99Q61HSH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8zGL14FHvDXo3m-CQB7SB6u5YwYgKKb0',
    appId: '1:614806614589:android:f0a3d1b44290dfaffd3054',
    messagingSenderId: '614806614589',
    projectId: 'paywise-0220',
    storageBucket: 'paywise-0220.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyACMMl_5iJ_fMlurDBOV3oB3Xtw5cETgxE',
    appId: '1:614806614589:ios:0761a1f1ae3372affd3054',
    messagingSenderId: '614806614589',
    projectId: 'paywise-0220',
    storageBucket: 'paywise-0220.appspot.com',
    androidClientId: '614806614589-r7jcvb7bkvrc0h2vdn3orea3elfdnatb.apps.googleusercontent.com',
    iosClientId: '614806614589-ngn2bd65ih94kvl86rpj159lqr32eo7j.apps.googleusercontent.com',
    iosBundleId: 'com.example.paywise',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyACMMl_5iJ_fMlurDBOV3oB3Xtw5cETgxE',
    appId: '1:614806614589:ios:0761a1f1ae3372affd3054',
    messagingSenderId: '614806614589',
    projectId: 'paywise-0220',
    storageBucket: 'paywise-0220.appspot.com',
    androidClientId: '614806614589-r7jcvb7bkvrc0h2vdn3orea3elfdnatb.apps.googleusercontent.com',
    iosClientId: '614806614589-ngn2bd65ih94kvl86rpj159lqr32eo7j.apps.googleusercontent.com',
    iosBundleId: 'com.example.paywise',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBmXg4ZeEzk_R650yMpmEHkp5Mm20kJvmA',
    appId: '1:614806614589:web:923eebcdd5ccbcfefd3054',
    messagingSenderId: '614806614589',
    projectId: 'paywise-0220',
    authDomain: 'paywise-0220.firebaseapp.com',
    storageBucket: 'paywise-0220.appspot.com',
    measurementId: 'G-ME51GSL0M3',
  );

}