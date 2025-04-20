import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UlasanPage extends StatelessWidget {
  final List<Map<String, String>> ulasanList = [
    {
      "image": "assets/sample_food.png",
      "username": "Nomnom",
      "avatar": "assets/ex_profile.png",
      "likes": "30",
    },
    {
      "image": "assets/sample_food2.png",
      "username": "Bibimbul",
      "avatar": "assets/ex_profile2.png",
      "likes": "15",
    },
    {
      "image": "assets/sample_food.png",
      "username": "Nomnom",
      "avatar": "assets/ex_profile.png",
      "likes": "30",
    },
    {
      "image": "assets/sample_food2.png",
      "username": "Bibimbul",
      "avatar": "assets/ex_profile2.png",
      "likes": "15",
    },
    {
      "image": "assets/sample_food.png",
      "username": "Nomnom",
      "avatar": "assets/ex_profile.png",
      "likes": "30",
    },
    {
      "image": "assets/sample_food2.png",
      "username": "Bibimbul",
      "avatar": "assets/ex_profile2.png",
      "likes": "15",
    },
  ];

  UlasanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE52020), Color(0xFFA80707)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lokasi",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  "Bojongsoang, Bandung",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Temukan berbagai ulasan menarik di MakanGo!",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.66,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: ulasanList.length, // Gunakan panjang list ulasan
          itemBuilder: (context, index) {
            final ulasan = ulasanList[index]; // Ambil data sesuai index
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(
                      ulasan["image"]!, // Gunakan gambar dari list
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lorem ipsum dolor sit amet blablablabla citcitcit",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                ulasan["avatar"]!,
                              ), // Avatar berbeda
                              radius: 12,
                            ),
                            SizedBox(width: 8),
                            Text(
                              ulasan["username"]!, // Nama user berbeda
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.favorite_border,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              ulasan["likes"]!, // Jumlah like berbeda
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
