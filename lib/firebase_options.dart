import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    return android;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCIJaHB7zydAkeiT0UQUQ2zhJGAMUfR6OU',
    appId: '1:750325641235:web:2b961407fc0bc45df24fe6',
    messagingSenderId: '750325641235',
    projectId: 'group-trackers',
    authDomain: 'group-trackers.firebaseapp.com',
    storageBucket: 'group-trackers.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdwfWNNDLxWLegqubsAmiyB4UH_CdD6Ac',
    appId: '1:750325641235:android:21627707817af964f24fe6',
    messagingSenderId: '750325641235',
    projectId: 'group-trackers',
    storageBucket: 'group-trackers.firebasestorage.app',
  );
}