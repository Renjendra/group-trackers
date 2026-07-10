import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  String _toEmail(String username) {
    return "${username.toLowerCase()}@grouptracker.app";
  }

  Future<String?> register({
    required String username,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _toEmail(username),
        password: password,
      );

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