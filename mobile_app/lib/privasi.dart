import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

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
          "Privasi & Keamanan",
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
              "Privasi & Keamanan 🔒",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Di makanGo, privasi kamu prioritas utama kami! Yuk, kenalan sama aturan mainnya:",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            // Daftar Informasi
            _buildInfoItem(
              emoji: "📄",
              title: "Data yang Kami Kumpulkan",
              description:
                  "Kami hanya ambil data yang penting, kayak nama, email, dan lokasi (kalau kamu izinkan), buat ningkatin pengalaman kamu di aplikasi.",
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              emoji: "🔧",
              title: "Cara Kami Menggunakan Data",
              description:
                  "Data kamu dipakai untuk:\n\n"
                  "• Menampilkan rumah makan terdekat\n"
                  "• Menyesuaikan rekomendasi\n"
                  "• Menghubungi kamu kalau ada info penting",
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              emoji: "🛡️",
              title: "Keamanan Data",
              description:
                  "Kami pakai sistem enkripsi dan perlindungan ekstra biar datamu tetap aman dari tangan-tangan nakal.",
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              emoji: "✋",
              title: "Kontrol di Tangan Kamu",
              description:
                  "Kamu bisa atur izin lokasi, edit data pribadi, atau bahkan hapus akun kapan aja lewat menu Pengaturan.",
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              emoji: "🚫",
              title: "Tidak Ada Jual-Beli Data",
              description:
                  "Kami gak pernah jual atau kasih data kamu ke pihak lain tanpa izin.",
            ),
            const SizedBox(height: 32),
            // Penutup
            Text(
              "Kalau mau baca detail lengkapnya, cek Kebijakan Privasi kami ya! Atau kalau ada yang mau ditanyain, langsung aja kontak tim support makanGo. 🙌",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            // Tombol Kebijakan Privasi
            GestureDetector(
              onTap: () {
                // TODO: Navigasi ke halaman Kebijakan Privasi
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                // );
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
                    "Kebijakan Privasi",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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

  // Widget untuk item informasi
  Widget _buildInfoItem({
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
