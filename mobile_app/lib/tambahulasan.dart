import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makango/restaurant_model.dart';

class TambahUlasanPage extends StatefulWidget {
  final Restaurant restaurant;

  TambahUlasanPage({required this.restaurant});

  @override
  _TambahUlasanPageState createState() => _TambahUlasanPageState();
}

class _TambahUlasanPageState extends State<TambahUlasanPage> {
  double rating = 4.7;
  int makananRating = 4;
  int pelayananRating = 4;
  int suasanaRating = 4;
  TextEditingController ulasanController = TextEditingController();

  Widget buildStarRating(int rating, Function(int) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () => onChanged(index + 1),
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Tambah Ulasan", style: GoogleFonts.poppins(fontSize: 18)),
        leading: IconButton(
          icon: Icon(Icons.close, color: const Color(0xFFA80707)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: const Color(0xFFA80707)),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.restaurant.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.restaurant.address,
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: const Color(0xFFA80707),
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.restaurant.time,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFFA80707),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Rating ⭐ $rating",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Makanan",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buildStarRating(makananRating, (newRating) {
                        setState(() => makananRating = newRating);
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pelayanan",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buildStarRating(pelayananRating, (newRating) {
                        setState(() => pelayananRating = newRating);
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Suasana",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buildStarRating(suasanaRating, (newRating) {
                        setState(() => suasanaRating = newRating);
                      }),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Tulis ulasan lebih lengkap",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: ulasanController,
              maxLines: 5,
              maxLength: 5000, // Batas maksimum karakter
              decoration: InputDecoration(
                hintText: "Tulis ulasan Anda di sini...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                counterText:
                    "${ulasanController.text.length}/5000", // Indikator jumlah karakter
                counterStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ), // Styling counter
              ),
              onChanged: (text) {
                setState(() {}); // Biar counter teks ikut update
              },
            ),

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.camera_alt, color: const Color(0xFFA80707)),
                  label: Text(
                    "Tambah foto",
                    style: GoogleFonts.poppins(color: const Color(0xFFA80707)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: const Color(0xFFA80707)),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.videocam, color: const Color(0xFFA80707)),
                  label: Text(
                    "Tambah video",
                    style: GoogleFonts.poppins(color: const Color(0xFFA80707)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: const Color(0xFFA80707)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildSubmitReviewButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitReviewButton() {
    return GestureDetector(
      onTap: () {
        // Tambahkan aksi kirim ulasan di sini
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
            "Kirim ulasan",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
