import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Tombol Back
            // Tombol Back dengan Lingkaran & Shadow
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Warna lingkaran
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Warna shadow
                    blurRadius: 10, // Besar blur
                    spreadRadius: 2, // Sebaran shadow
                    offset: const Offset(0, 4), // Posisi shadow
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 30, color: Colors.red),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 20),
            // Logo & Judul
            Row(
              children: [
                Image.asset('assets/logo.png', width: 150), // Sesuaikan path
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
            // Judul Halaman
            Text(
              "Kode Verifikasi!",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Kode verifikasi telah terkirim melalui email ke\nc********4@gmail.com",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 30),
            // OTP Input
            OtpTextField(
              numberOfFields: 4,
              borderColor: Colors.grey,
              focusedBorderColor: Colors.red,
              showFieldAsBox: true,
              fieldWidth: 50,
              borderRadius: BorderRadius.circular(10),
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {
                print("Kode OTP: $verificationCode");
              },
            ),
            const SizedBox(height: 30),
            // Tombol Kirim
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ), // Ganti NextPage dengan tujuan
                );
              },
              child: Container(
                width: double.infinity, // Lebar full
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ), // Tinggi tombol
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE52020),
                      Color(0xFFA80707),
                    ], // Warna gradien
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(50), // Bikin rounded
                ),
                child: Center(
                  child: Text(
                    "Lanjutkan",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Warna teks
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
