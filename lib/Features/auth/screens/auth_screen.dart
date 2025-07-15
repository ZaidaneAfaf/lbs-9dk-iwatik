import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import '../controllers/auth_controller.dart';
import '../../Admin/screens/acceuil_admin.dart';
import '../../Couturier/screens/acceuil_couturier.dart';
import '../../Client/screens/acceuil_client.dart';
import 'role_selection_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthController _authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final role = await _authController.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Connexion réussie !"),
          backgroundColor: Colors.green,
        ),
      );

      Widget nextScreen;

      switch (role) {
        case 'admin':
          nextScreen = const AdminHomePage();
          break;
        case 'couturier':
          nextScreen = const CouturierHomePage();
          break;
        default:
          nextScreen = const ClientHomePage();
          break;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFFE91E63),
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
      style: TextStyle(color: Colors.grey[800]),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return isPassword ? 'Veuillez entrer un mot de passe' : 'Veuillez entrer un email';
        }
        if (!isPassword &&
            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Email invalide';
        }
        if (isPassword && value.length < 6) {
          return 'Le mot de passe doit faire au moins 6 caractères';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: screenHeight * 0.35 + topPadding,
              width: screenWidth,
              padding: EdgeInsets.only(top: topPadding),
              decoration: const BoxDecoration(
                color: Color(0xFFFDDFE3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logo_lbs9dkiwatik.png',
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.25,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.account_circle, size: 160, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'Login',
                            style: GoogleFonts.aladin(
                              fontSize: screenWidth * 0.13,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 243, 68, 92),
                              letterSpacing: 1.0,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.15),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildLabel("Email"),
                        _buildTextField(_emailController, "Email", false),
                        const SizedBox(height: 20),
                        _buildLabel("Password"),
                        _buildTextField(_passwordController, "Password", true),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE91E63),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                : const Text('Sign In',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RoleSelectionScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Create Account',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400)),
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fonctionnalité à implémenter')),
                            );
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
