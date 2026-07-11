import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirestoreService _firestoreService = FirestoreService();

  User? get currentUser => _auth.currentUser;

  String _toEmail(String username) {
    return "${username.toLowerCase()}@grouptracker.app";
  }

  Future<String?> register({
    required String username,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: _toEmail(username),
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        await _firestoreService.createUser(
          UserModel(
            uid: user.uid,
            username: username,
            createdAt: Timestamp.now(),
          ),
        );
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _toEmail(username),
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}