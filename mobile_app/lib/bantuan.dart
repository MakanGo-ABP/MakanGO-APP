import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFFA80707)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Bantuan",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Halo, Sobat makanGo! 👋",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Kalau kamu butuh bantuan, sini kami bantu jelasin:",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            // Daftar Panduan
            _buildGuideItem(
              emoji: "🔍",
              title: "Cari Rumah Makan",
              description:
                  "Ketik nama rumah makan atau jenis makanan di kolom pencarian untuk menemukan tempat yang kamu mau.",
            ),
            const SizedBox(height: 16),
            _buildGuideItem(
              emoji: "🌟",
              title: "Lihat Review",
              description:
                  "Klik nama rumah makan untuk lihat review dari pengguna lain. Ada rating, komentar, dan foto juga, lho!",
            ),
            const SizedBox(height: 16),
            _buildGuideItem(
              emoji: "📝",
              title: "Tambah Review",
              description:
                  "Udah makan? Bagikan pengalamanmu dengan klik tombol \"Tulis Review\". Biar pengguna lain terbantu dengan ceritamu!",
            ),
            const SizedBox(height: 16),
            _buildGuideItem(
              emoji: "⚙️",
              title: "Filter & Urutkan",
              description:
                  "Mau cari yang rating tinggi atau deket dari lokasi kamu? Pakai fitur filter dan sortir untuk hasil yang lebih sesuai.",
            ),
            const SizedBox(height: 16),
            _buildGuideItem(
              emoji: "❤️",
              title: "Favoritkan Rumah Makan",
              description:
                  "Suka sama tempatnya? Klik ikon hati supaya gampang ditemukan lagi nanti!",
            ),
            const SizedBox(height: 32),
            // Penutup
            Text(
              "Kalau ada pertanyaan atau kendala, langsung aja hubungi tim support kami lewat menu Hubungi Kami ya.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Selamat berburu kuliner seru bareng makanGo! 🍴✨",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            // Tombol Hubungi Kami
            // GestureDetector(
            //   onTap: () {
            //     // TODO: Navigasi ke halaman Hubungi Kami
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(builder: (context) => ContactUsPage()),
            //     // );
            //   },
            //   child: Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.symmetric(vertical: 15),
            //     decoration: BoxDecoration(
            //       gradient: const LinearGradient(
            //         colors: [Color(0xFFE52020), Color(0xFFA80707)],
            //         begin: Alignment.topLeft,
            //         end: Alignment.bottomRight,
            //       ),
            //       borderRadius: BorderRadius.circular(50),
            //     ),
            //     child: Center(
            //       child: Text(
            //         "Hubungi Kami",
            //         style: GoogleFonts.poppins(
            //           fontSize: 14,
            //           fontWeight: FontWeight.w500,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget untuk item panduan
  Widget _buildGuideItem({
    required String emoji,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
