import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/main.dart';
import 'email_page.dart';
import 'package:mobile_app/services/auth.services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bglogin.png', // Ganti dengan background-mu
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 20),
              Container(
                constraints: const BoxConstraints(
                  minHeight: 300, // Ubah tinggi minimum box putih
                ),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ), // Padding kiri & kanan
                      child: Text(
                        "Ayo Daftar untuk Melanjutkan!",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center, // Biar teks rata tengah
                      ),
                    ),

                    const SizedBox(height: 10), // Jarak ke bawah

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ), // Padding kiri & kanan
                      child: Text(
                        "Untuk melanjutkan, Anda perlu membuat akun. Pilih metode login di bawah",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center, // Biar teks rata tengah
                        softWrap: true, // Supaya wrapping otomatis
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Button Login Email
                    // Button dengan Gradien
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailPage(),
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
                          borderRadius: BorderRadius.circular(
                            50,
                          ), // Bikin rounded
                        ),
                        child: Center(
                          child: Text(
                            "Lanjut dengan Email",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white, // Warna teks
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    // Button Login Google
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        User? user = await authService.signInWithGoogle();
                        if (user != null) {
                          final userRef = _firestore.collection('User').doc(user.uid);

                          // Check if the user already exists
                          final userDoc = await userRef.get();
                          if (!userDoc.exists) {
                            // If user does not exist, add the new user to the collection
                            await userRef.set({
                              'name': user.displayName,
                              'email': user.email,
                              'uid': user.uid,
                              'created_at': FieldValue.serverTimestamp(),
                            });
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Berhasil masuk sebagai ${user.displayName}",
                              ),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Google Sign-In dibatalkan"),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google_logo.png',
                            width: 20,
                          ), // Tambahkan logo Google
                          const SizedBox(width: 10),
                          Text(
                            "Lanjut dengan Google",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
