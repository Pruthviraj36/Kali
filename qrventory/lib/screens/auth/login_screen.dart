import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = 'user';

  bool _isLoading = false;
  String? _errorMessage;
  bool _isLogin = true;
  bool _obscureText = true; // For password visibility toggle

  final AuthService _authService = AuthService();

  Future<void> _submitForm() async {
    // ... (Keep the _submitForm logic from the previous response)
    // The UI changes below don't affect this core logic.
    // For brevity, I'm omitting it here, but it should be the same as before.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      User? user;
      try {
        if (_isLogin) {
          user = await _authService.signIn(
            _emailController.text.trim(),
            _passwordController.text,
          );
          if (user == null && mounted) {
            setState(() {
              _errorMessage = 'Login failed. Please check your credentials.';
            });
          }
        } else {
          user = await _authService.register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
            _selectedRole,
          );
          if (user == null && mounted) {
            setState(() {
              _errorMessage = 'Registration failed. The email might already be in use or the password is too weak.';
            });
          } else if (user != null && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful! Please login.')),
            );
            setState(() {
              _isLogin = true;
              _clearControllers();
            });
          }
        }

        if (user != null && mounted) {
          print('${_isLogin ? "Signed in" : "Registered"}: ${user.uid}');
          // Navigation is typically handled by AuthWrapper
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          setState(() {
            // More specific error messages
            if (e.code == 'user-not-found' || e.code == 'INVALID_LOGIN_CREDENTIALS') { // INVALID_LOGIN_CREDENTIALS is a common code too
              _errorMessage = 'Invalid email or password.';
            } else if (e.code == 'wrong-password') {
              _errorMessage = 'Invalid email or password.';
            } else if (e.code == 'invalid-email') {
              _errorMessage = 'The email address is not valid.';
            } else if (e.code == 'email-already-in-use') {
              _errorMessage = 'The email address is already in use.';
            } else if (e.code == 'weak-password') {
              _errorMessage = 'The password is too weak.';
            }
            else if (e.code == 'network-request-failed') {
              _errorMessage = 'Network error. Please check your connection.';
            }
            else {
              _errorMessage = 'An error occurred. Please try again.';
              print('Firebase Auth Error: ${e.code} - ${e.message}');
            }
          });
        }
      }
      catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = 'An unexpected error occurred.';
          });
        }
        print('Error during auth process: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _clearControllers() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Removed AppBar for a cleaner, more modern look.
      // Can add a custom one if needed or rely on back navigation if pushed.
      body: SafeArea( // Ensures content is not obscured by system UI
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox( // Ensures the form doesn't get too wide on tablets
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // --- App Logo/Icon (Optional) ---
                    FlutterLogo(size: _isLogin ? 80 : 60, textColor: theme.primaryColor),
                    const SizedBox(height: 24),

                    // --- Title ---
                    Text(
                      _isLogin ? 'Welcome Back!' : 'Create an Account',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (_isLogin)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 24.0),
                        child: Text(
                          'Login to continue',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                    if (!_isLogin) const SizedBox(height: 24),


                    // --- Error Message ---
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: theme.colorScheme.error.withOpacity(0.5))
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: theme.colorScheme.error, fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // --- Registration Fields ---
                    if (!_isLogin) ...[
                      _buildTextField(
                        controller: _nameController,
                        labelText: 'Full Name',
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (!_isLogin && (value == null || value.isEmpty)) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // --- Email Field ---
                    _buildTextField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // --- Password Field ---
                    _buildTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- Role Selection (Registration Only) ---
                    if (!_isLogin) ...[
                      _buildDropdownField(
                        value: _selectedRole,
                        labelText: 'Select Role',
                        prefixIcon: Icons.work_outline,
                        items: ['user', 'editor', 'admin']
                            .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role.capitalize()),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedRole = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (!_isLogin && (value == null || value.isEmpty)) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // --- Forgot Password (Login Only) ---
                    if (_isLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement Forgot Password Logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Forgot Password clicked (not implemented yet).')),
                            );
                          },
                          child: Text('Forgot Password?', style: TextStyle(color: theme.primaryColor)),
                        ),
                      ),
                    if (_isLogin) const SizedBox(height: 24),


                    // --- Submit Button ---
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2, // Subtle shadow
                      ),
                      child: Text(_isLogin ? 'Login' : 'Create Account'),
                    ),
                    const SizedBox(height: 20),

                    // --- Toggle Login/Register ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin ? 'Don\'t have an account?' : 'Already have an account?',
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                              _errorMessage = null;
                              _formKey.currentState?.reset(); // Reset form validation state
                              _clearControllers();
                            });
                          },
                          child: Text(
                            _isLogin ? 'Sign Up' : 'Sign In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build consistent TextFormFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? prefixIcon,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: theme.primaryColor.withOpacity(0.7)) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
    );
  }

  // Helper method for Dropdown
  Widget _buildDropdownField({
    required String value,
    required String labelText,
    required IconData prefixIcon,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?)? onChanged,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: theme.primaryColor.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}

// Helper extension (keep or move to utils)
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}