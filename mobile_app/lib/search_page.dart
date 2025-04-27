import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/services/restaurant_match.dart';
import 'package:mobile_app/services/restaurant_services.dart';
import 'restaurantdetail_page.dart';
import 'tambahulasan.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final RestaurantService _restaurantService = RestaurantService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
        child: Container(
          decoration: const BoxDecoration(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "Bingung mau Makan apa? temukan beragam review di MakanGo",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: 380,
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
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: "—Cari makanan...",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {}); // Update search results
                          },
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hasil Pencarian",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<RestaurantMatch>>(
                stream: _restaurantService.searchRestaurants(
                  _searchController.text,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada restoran ditemukan',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    );
                  }
                  final restaurantMatches = snapshot.data!;
                  return Column(
                    children:
                        restaurantMatches.map((match) {
                          return _buildRestaurantCard(match, context);
                        }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(RestaurantMatch match, BuildContext context) {
    final restaurant = match.restaurant;
    final matchedFields = match.matchedFields;
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
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.asset(
                    restaurant.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
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
                      const SizedBox(height: 5),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth * 0.7,
                            child: Text(
                              'Matched: ${matchedFields.join(', ').replaceAll('name', 'Nama').replaceAll('category', 'Kategori').replaceAll('address', 'Alamat')}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.blue,
                                fontStyle: FontStyle.italic,
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
                              const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              ),
                              const SizedBox(width: 5),
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
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE52020), Color(0xFFA80707)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1).replaceAll('.', ','),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            reviews.toString(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
