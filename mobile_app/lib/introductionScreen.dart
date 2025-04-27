import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mobile_app/login.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,

      pages: [
        PageViewModel(
          image: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Container(
                width: 500, // Increased width
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/intro1.png'),
                    fit: BoxFit.contain, // Adjusted to resize the image
                  ),
                ),
              ),
            ),
          ),
          titleWidget: Text(
            "Menemukan Tempat Makan",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFFA80707),
              ),
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Putuskan pilihan Anda dengan melihat apa yang dikatakan orang lain tentang restoran tersebut.",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
        PageViewModel(
          image: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/intro2.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          titleWidget: Text(
            "Mengulas & Dapatkan XP",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFFA80707),
              ),
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Bagikan pemikiran Anda dan dapatkan XP untuk setiap ulasan. Berbagi berarti peduli!",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
        PageViewModel(
          image: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/intro3.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          titleWidget: Text(
            "Ulasanmu Membuat Perubahan!",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFFA80707),
              ),
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Berikan ulasan jujurmu, dapatkan XP, dan bantu restoran lokal berkembang. Satu kata darimu bisa berarti banyak!",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
      ],
      onDone:
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          ),
      onSkip:
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          ),
      showSkipButton: true,
      skip: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            "Lewati",
            style: GoogleFonts.poppins(
              color: Color(0xFFA80707),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      next: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          constraints: const BoxConstraints(minWidth: 120),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE52020), Color(0xFFA80707)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            "Berikutnya",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      done: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE52020), Color(0xFFA80707)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            "Selesai",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10, 10),
        activeSize: Size(22, 10),
        color: Color.fromARGB(255, 213, 213, 213),
        activeColor: Color(0xFFA80707),
        spacing: EdgeInsets.symmetric(horizontal: 3),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }
}
