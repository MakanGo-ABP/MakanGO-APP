import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:makango/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/services/auth.services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true; // Toggle untuk visibilitas password
  String? _errorMessage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(29.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildBackButton(context),
              const SizedBox(height: 20),
              _buildLogo(),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 30),
              _buildTextField(
                controller: _nameController,
                label: "Nama Lengkap",
                hint: "Masukkan nama Anda...",
                customIcon: Padding(
                  padding: const EdgeInsets.only(left: 19.0, right: 9),
                  child: Image.asset(
                    'assets/logo_user.png',
                    width: 12,
                    height: 12,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                isPassword: false,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                label: "Email",
                hint: "Masukkan email Anda...",
                customIcon: Padding(
                  padding: const EdgeInsets.only(left: 19.0, right: 9),
                  child: Image.asset(
                    'assets/logo_email.png',
                    width: 25,
                    height: 19,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                isPassword: false,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                label: "Kata Sandi",
                hint: "Masukkan kata sandi Anda...",
                customIcon: Padding(
                  padding: const EdgeInsets.only(left: 19.0, right: 9),
                  child: Image.asset(
                    'assets/logo_key.png',
                    width: 25,
                    height: 19,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                isPassword: true,
              ),
              const SizedBox(height: 20),
              // Display the error message if it's not null
              if (_errorMessage != null) 
                _buildErrorMessage(_errorMessage!),
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Error message UI
  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _getFriendlyErrorMessage(dynamic error) {
  // Example of Firebase Authentication error handling
  if (error.toString().contains('email')) {
    return "Format email tidak valid.";
  } else if (error.toString().contains('password')) {
    return "Kata sandi harus terdiri dari minimal 6 karakter.";
  } else if (error.toString().contains('already in use')) {
    return "Email ini sudah terdaftar. Silakan gunakan email lain.";
  } else {
    // Default fallback message
    return "Terjadi kesalahan. Silakan coba lagi.";
  }
}


  // Tombol Kembali
  Widget _buildBackButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, size: 30, color: Colors.red),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // Logo Aplikasi
  Widget _buildLogo() {
    return Row(children: [Image.asset('assets/logo.png', width: 150)]);
  }

  // Judul Halaman
  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Registrasi akun!",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "Email yang Anda masukkan belum terdaftar",
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  // Widget Helper untuk Input Field
  Widget _buildTextField({
    required String label,
    required String hint,
    IconData? icon,
    Widget? customIcon,
    required bool isPassword, 
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: [
              TextSpan(text: " *", style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),

        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            prefixIcon:
                customIcon ??
                (icon != null ? Icon(icon, color: Colors.grey) : null),
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  // Tombol Submit
  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () async {
        final String name = _nameController.text.trim(); // Get name input
        final String email = _emailController.text.trim(); // Get email input
        final String password = _passwordController.text.trim(); // Get password input

        try {
          final userCredential = await _authService.createAccount(
            email: email,
            password: password,
          );
          await _authService.updateUsername(username: name);
          await _authService.saveUserData(
            uid: userCredential.user!.uid,
            name: name,
            email: email,
          );

          Fluttertoast.showToast(msg: "Registrasi berhasil!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } catch (e) {
          setState(() {
            _errorMessage = _authService.getFriendlyErrorMessage(e);
          });
        }
        },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE52020), Color(0xFFA80707)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            "Masuk",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}