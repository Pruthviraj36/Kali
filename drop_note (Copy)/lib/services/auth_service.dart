import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Login", "Login successful");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  static Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Sign Up", "Account created successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  static void resetPassword(String email) {
    _auth.sendPasswordResetEmail(email: email);
    Get.snackbar("Reset Email", "Check your inbox for password reset link");
  }

  static void logout() {
    _auth.signOut();
  }
}