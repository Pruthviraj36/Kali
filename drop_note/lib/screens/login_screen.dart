import 'package:drop_note/screens/forgot_password.dart';
import 'package:drop_note/screens/sign_up.dart';
import 'package:drop_note/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final AuthServices _authServices = AuthServices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool showPassword = false;
  bool isLoading = false;

  void showSnackBar(String message, {bool isError = false}) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<void> _login() async {
    setState(() => isLoading = true);
    try {
      await _authServices.login(emailController.text, passwordController.text);
      showSnackBar('Login successful');
      emailController.clear();
      passwordController.clear();
      setState(() {
        isLogin = true;
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message ?? 'Login failed', isError: true);
    } catch (e) {
      showSnackBar('Login failed', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ignore: unused_element
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                // FORGET PASSWORD
                TextButton(
                  onPressed: () {
                    Get.to(() => ForgotPassword());
                    print("navigated to fogot page");
                  },
                  child: Text('Forget Password'),
                ),
                const SizedBox(height: 16.0),
                // LOGIN BUTTON
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _login();
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
                      : Text(isLogin ? 'Login' : 'Register'),
                ),
                SizedBox(height: 16.0),

                // SWITCH TO REGISTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isLogin ? 'Not a member?' : 'Already a member?'),
                    TextButton(
                      onPressed: () {
                        isLogin = !isLogin;
                        Get.to(SignUp());
                        setState(() {});
                      },
                      child: Text(isLogin ? 'Register' : 'Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
