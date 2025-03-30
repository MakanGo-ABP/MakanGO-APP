import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:makango/dashboard.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true; // Toggle untuk visibilitas password

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
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ), // Ganti NextPage dengan tujuan
        );
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
}
