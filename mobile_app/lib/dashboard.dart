import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'restaurantdetail_page.dart';
import 'search_page.dart';
import 'tambahulasan.dart';
import 'model/restaurant_model.dart';
import 'package:mobile_app/services/restaurant_services.dart';
import 'notifikasi.dart';
import 'package:mobile_app/services/profile_service.dart';
import 'package:mobile_app/services/restaurant_match.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/services/auth.services.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final RestaurantService _restaurantService = RestaurantService();
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();
  String? _selectedCategory; // Track the selected category

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
                  _buildSectionTitle("Tempat Populer"),
                  const SizedBox(height: 10),
                  _selectedCategory == null
                      ? _buildAllRestaurants()
                      : _buildFilteredRestaurants(_selectedCategory!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllRestaurants() {
    return StreamBuilder<List<Restaurant>>(
      stream: _restaurantService.getRestaurants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching restaurants: ${snapshot.error}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No restaurants found'),
          );
        }
        final restaurants = snapshot.data!;
        return Column(
          children: restaurants.map((restaurant) {
            return _buildRestaurantCard(restaurant, context);
          }).toList(),
        );
      },
    );
  }

  Widget _buildFilteredRestaurants(String category) {
    return StreamBuilder<List<RestaurantMatch>>(
      stream: _restaurantService.searchRestaurants(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error searching restaurants: ${snapshot.error}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No restaurants match the selected category'),
          );
        }
        final restaurantMatches = snapshot.data!;
        return Column(
          children: restaurantMatches.map((match) {
            return _buildRestaurantCard(match.restaurant, context);
          }).toList(),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 350,
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
                                    const SizedBox(width: 5),
                                    Text(
                                      "Lokasi",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
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
                        StreamBuilder<QuerySnapshot>(
                          stream: _authService.currentUser != null
                              ? FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(_authService.currentUser!.uid)
                                  .collection('Notifications')
                                  .where('isRead', isEqualTo: false)
                                  .snapshots()
                              : null,
                          builder: (context, snapshot) {
                            int unreadCount = 0;
                            if (snapshot.hasData) {
                              unreadCount = snapshot.data!.docs.length;
                            }
                            return Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotificationPage(),
                                      ),
                                    );
                                  },
                                  child: Image.asset(
                                    "assets/logo_notifikasi.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                if (unreadCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFAA00),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        unreadCount.toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: _profileService.getName(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                "Hi, ${snapshot.data}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                "Hi, Error",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            } else {
                              String name = snapshot.data ?? "User";
                              String truncatedName =
                                  name.length > 150
                                      ? name.substring(0, 150) + "..."
                                      : name;
                              return Text(
                                "Hi, $truncatedName",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
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
              bottom: 80,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCategoryGrid() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 25,
        runSpacing: 16,
        children: [
          _buildCategoryItem("assets/kategori_nusantara.png", "Nusantara"),
          _buildCategoryItem("assets/kategori_bakmie.png", "Bakmie"),
          _buildCategoryItem("assets/kategori_japanese.png", "Jepang"),
          _buildCategoryItem("assets/kategori_chinese.png", "Cina"),
          _buildCategoryItem("assets/kategori_cepatsaji.png", "Cepat Saji"),
          _buildCategoryItem("assets/kategori_sweets.png", "Penutup Manis"),
          _buildCategoryItem("assets/kategori_sarapan.png", "Sarapan"),
          _buildCategoryItem("assets/kategori_minuman.png", "Minuman"),
          _buildCategoryItem("assets/kategori_seafoods.png", "Seafood"),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String imagePath, String title) {
    bool isSelected = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle category: if the same category is tapped, clear the filter
          _selectedCategory = isSelected ? null : title;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.red : Colors.transparent,
                width: 2,
              ),
            ),
            child: Image.asset(imagePath, width: 50, height: 50),
          ),
          SizedBox(height: 8, width: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isSelected ? Colors.red : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
                  child: restaurant.imagePath.startsWith('http')
                      ? Image.network(
                          restaurant.imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          ),
                        )
                      : Image.asset(
                          restaurant.imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          ),
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
                            width: constraints.maxWidth * 0.7,
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
                            width: constraints.maxWidth * 0.7,
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
                      const SizedBox(height: 5),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth * 0.7,
                            child: Text(
                              restaurant.address,
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
                              builder: (context) =>
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
                colors: [Color(0xFFE52020), Color(0xFFA80707)],
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