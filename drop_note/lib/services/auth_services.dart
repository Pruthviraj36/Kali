import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_note/screens/home_screen.dart';
import 'package:drop_note/services/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addUser(String email, String username) {
    _firestore.collection('users').add({
      'email': email,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>> getUsers() async {
    final snapshot = await _firestore.collection('users').get();
    Map<String, dynamic> users = {};
    for (var doc in snapshot.docs) {
      users[doc['username']] = doc.data();
    }
    return users;
  }

  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignIn signIn = GoogleSignIn.instance;
  //   final GoogleSignInAccount? account = await GoogleSignIn.instance.signIn();

  //   // if (googleSignIn.supportsAuthenticate()) {
  //   //   final account = await googleSignIn.authenticate();
  //   // } else {
  //   //   // logic to be implemented (for platform that do not support authenticate())
  //   // }

  //   if (account == null)
  //     throw FirebaseAuthException(
  //       code: "ERROR_SIGN_IN_ABORTED_BY_USER",
  //       message: "Sign in aborted by user",
  //     );

  //   final googleAuth = await account.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   return await _auth.signInWithCredential(credential);
  // }

  // Future<UserCredential> signInWithGoogle() async {
  //   if (kIsWeb) {
  //     // For web, use Firebase's signInWithPopup
  //     GoogleAuthProvider authProvider = GoogleAuthProvider();
  //     return await _auth.signInWithPopup(authProvider);
  //   } else {
  //     // For mobile/desktop
  //     final GoogleSignIn googleSignIn = GoogleSignIn();
  //     final GoogleSignInAccount? account = await googleSignIn.signIn();
  //     if (account == null) {
  //       throw FirebaseAuthException(
  //         code: "ERROR_SIGN_IN_ABORTED_BY_USER",
  //         message: "Sign in aborted by user",
  //       );
  //     }
  //     final GoogleSignInAuthentication googleAuth =
  //         await account.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     return await _auth.signInWithCredential(credential);
  //   }
  // }

  Future<UserCredential> login(String email, String password) async {
    if (kIsWeb) await _auth.setPersistence(Persistence.LOCAL);
    var result = _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await SharedPrefs.setLogin(true);
    return result;
  }

  Future<void> sendVerficationLink() async {
    final user = _auth.currentUser;
    await user!.sendEmailVerification().then(
      (value) => Get.snackbar(
        'Link sent',
        'A link has been sent to your email',
        margin: EdgeInsets.all(30.0),
      ),
    );
  }

  Future<void> relod() async {
    await _auth.currentUser!.reload().then((value) => HomeScreen());
  }

  Future<void> reset(String email) async {
    if (kIsWeb) await _auth.setPersistence(Persistence.LOCAL);
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw FirebaseAuthException(
        code: "ERROR_RESET_PASSWORD_FAILED",
        message: e.toString(),
      );
    }
  }

  Future<UserCredential> register(String email, String password) async {
    if (kIsWeb) await _auth.setPersistence(Persistence.LOCAL);
    var result = _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await SharedPrefs.setLogin(true);
    return result;
  }

  Future<void> logout() async {
    await _auth.signOut();
    await SharedPrefs.clearLogin();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
