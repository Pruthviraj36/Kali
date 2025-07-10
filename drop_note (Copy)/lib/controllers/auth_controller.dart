import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    await AuthService.login(email, password);
  }

  void signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    await AuthService.signUp(email, password);
  }

  void resetPassword(String email) {
    AuthService.resetPassword(email);
  }

  void logout() {
    AuthService.logout();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}