import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'restaurantdetail_page.dart';
import 'search_page.dart';
import 'tambahulasan.dart';
import 'restaurant_model.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final List<Restaurant> restaurants = [
    Restaurant(
      name: "McDonalds - Podomoro Park",
      imagePath: "assets/card_mcd.png",
      time: "00:00 - 23:59",
      category: "Cepat saji, Ayam, Makanan penutup, Ice cream",
      rating: 4.8,
      reviews: 150,
      address:
          "Jl. Podomoro Boulevard Utara No.1, Lengkong, Kec. Bojongsoang, Kabupaten Bandung, Jawa Barat 40287",
    ),
    Restaurant(
      name: "Mixue Bojongsoang",
      imagePath: "assets/card_mixue.png",
      time: "10:00 - 21:00",
      category: "Makanan lezat dengan pemandangan indah.",
      rating: 4.8,
      reviews: 150,
      address:
          "Jl. Terusan Buah Batu, Lengkong, Kec. Bojongsoang, Kabupaten Bandung, Jawa Barat 40287",
    ),
    Restaurant(
      name: "Mie Ayam Bakso Jabrig",
      imagePath: "assets/card_jabrig.png",
      time: "09:00 - 21:00",
      category: "Hidangan khas yang bikin ketagihan.",
      rating: 4.5,
      reviews: 120,
      address:
          "Gg. PGA, Lengkong, Kec. Bojongsoang, Kabupaten Bandung, Jawa Barat 40287",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Aneka Kuliner Menarik"),
                  const SizedBox(height: 10),
                  _buildCategoryGrid(),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Tempat Populer Terdekat"),
                  const SizedBox(height: 10),
                  Column(
                    children:
                        restaurants
                            .map(
                              (restaurant) =>
                                  _buildRestaurantCard(restaurant, context),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none, // Supaya search bar bisa keluar dari header
          children: [
            Container(
              height: 350, // Tambah tinggi agar search bar muat
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bgdashboard.png"),
                  fit: BoxFit.fill,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Bagian Lokasi
                        Row(
                          children: [
                            Image.asset(
                              "assets/logo_v2.png",
                              width: 45,
                              height: 45,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/logo_lokasi.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ), // Kasih jarak kecil
                                    Text(
                                      "Lokasi",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ), // Jarak kecil ke bawah
                                Text(
                                  "Bojongsoang, Bandung",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Bagian Notifikasi
                        Stack(
                          alignment:
                              Alignment
                                  .centerRight, // Pastikan ikon sejajar kanan
                          children: [
                            Image.asset(
                              "assets/logo_notifikasi.png",
                              width:
                                  50, // Ubah ukuran supaya lebih proporsional
                              height: 50,
                            ),
                            Positioned(
                              right: 0, // Biar mepet ke kanan
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFAA00),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "2",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, Nabilah",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Selamat datang di MakanGo!",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 80, // Supaya search bar keluar dari header
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ), // Ganti NextPage dengan tujuan
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(
                        "Cari Makanan ...",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Expanded(
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //       hintText: "Cari makanan...",
                      //       border: InputBorder.none,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ), // Tambahkan jarak agar konten setelahnya tidak ketutupan
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  //Buat bagian aneka kuliner menarik
  Widget _buildCategoryGrid() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 25,
        runSpacing: 16,
        children: [
          _buildCategoryItem("assets/kategori_terdekat.png", "Terdekat"),
          _buildCategoryItem("assets/kategori_nusantara.png", "Nusantara"),
          _buildCategoryItem("assets/kategori_bakmie.png", "Bakmie"),
          _buildCategoryItem("assets/kategori_japanese.png", "Japanese"),
          _buildCategoryItem("assets/kategori_chinese.png", "Chinese"),
          _buildCategoryItem("assets/kategori_cepatsaji.png", "Cepat Saji"),
          _buildCategoryItem("assets/kategori_sweets.png", "Sweets"),
          _buildCategoryItem("assets/kategori_sarapan.png", "Sarapan"),
          _buildCategoryItem("assets/kategori_minuman.png", "Minuman"),
          _buildCategoryItem("assets/kategori_seafoods.png", "Seafood"),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String imagePath, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, width: 50, height: 50),
        SizedBox(height: 8, width: 10),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailPage(restaurant: restaurant),
          ),
        );
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white,
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    restaurant.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width:
                                constraints.maxWidth *
                                0.7, // Batasin lebar teks
                            child: Text(
                              restaurant.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.red.shade500,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            restaurant.time,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width:
                                constraints.maxWidth *
                                0.7, // Batasin lebar teks
                            child: Text(
                              restaurant.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      TambahUlasanPage(restaurant: restaurant),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE52020), Color(0xFFA80707)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, color: Colors.white, size: 15),
                              SizedBox(width: 5),
                              Text(
                                "Tambah Ulasan",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 160,
            right: 20,
            child: _buildRatingBox(restaurant.rating, restaurant.reviews),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBox(double rating, int reviews) {
    return Container(
      width: 80,
      height: 65,
      padding: EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE52020), Color(0xFFA80707)], // Warna gradien
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 18),
                SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1).replaceAll('.', ','),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6),
          Text(
            reviews.toString(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
