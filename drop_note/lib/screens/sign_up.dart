// ignore: unused_import
import 'package:drop_note/screens/home_screen.dart';
import 'package:drop_note/screens/login_screen.dart';
import 'package:drop_note/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool isLoading = false;
  bool isLogin = true;
  final AuthServices _authServices = AuthServices();

  Map<String, dynamic> users = {};

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    users = await _authServices.getUsers();
    setState(() {});
  }

  void showSnackBar(String message, {bool isError = false}) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<void> _register() async {
    setState(() => isLoading = true);
    try {
      await _authServices.register(
        emailController.text,
        passwordController.text,
      );
      emailController.clear();
      passwordController.clear();
      confirmController.clear();
      showSnackBar('Registration successful');
      setState(() {
        isLogin = true;
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message ?? 'Registration failed', isError: true);
    } catch (e) {
      showSnackBar('Registration failed', isError: true);
    } finally {
      setState(() => isLoading = false);
      await _authServices.sendVerficationLink().then(
        (value) => Get.offAll(() => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // USERNAME
                TextFormField(
                  controller: usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter a username';
                    if (value.length < 3)
                      return 'Username must be at least 3 characters';
                    if (users.containsKey(value))
                      return 'Username already exists';
                    if (users.isEmpty) return null;
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // EMAIL
                TextFormField(
                  controller: emailController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter an email'
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // PASSWORD
                TextFormField(
                  controller: passwordController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a password'
                      : null,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // LOGIN BUTTON
                Column(
                  children: [
                    // CONFIRM PASSWORD
                    TextFormField(
                      controller: confirmController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    //REGISTER BUTTON
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _register();
                              }
                            },
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: Colors.white,
                              ),
                            )
                          : Text('Register'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
