import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp.dart';

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

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
                    // ignore: deprecated_member_use
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
              "Hi! selamat datang di MakanGo",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Masukkan email Anda untuk menggunakan aplikasi",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Akun Email Anda",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            // Input Email
            TextField(
              decoration: InputDecoration(
                hintText: "Masukkan email Anda...",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 19.0, right: 9),
                  child: Image.asset(
                    'assets/logo_email.png',
                    width: 25,
                    height: 19,
                  ), // Sesuaikan path
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Tombol Kirim
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpPage(),
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
                    "Kirim",
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
