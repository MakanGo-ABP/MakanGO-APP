import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailUlasanPage extends StatelessWidget {
  final String image;
  final String username;
  final String avatar;
  final String likes;

  const DetailUlasanPage({
    super.key,
    required this.image,
    required this.username,
    required this.avatar,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Ulasan", style: GoogleFonts.poppins()),
        backgroundColor: Colors.red[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(image, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(backgroundImage: AssetImage(avatar)),
                  SizedBox(width: 12),
                  Text(
                    username,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.favorite, color: Colors.red),
                  SizedBox(width: 4),
                  Text(
                    "$likes likes",
                    style: GoogleFonts.poppins(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Ini adalah ulasan lengkap dari pengguna tentang makanan yang diunggah. Kamu bisa isi bagian ini sesuai konten sebenarnya.",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
