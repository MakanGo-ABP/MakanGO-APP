import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_app/detailulasan.dart';
import 'model/restaurant_model.dart';
import 'tambahulasan.dart';
import 'package:mobile_app/services/openstreetmap_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RestaurantDetailPage extends StatelessWidget {
  final Restaurant restaurant;
  final OpenStreetMapService _openStreetMapService = OpenStreetMapService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RestaurantDetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: const Color(0xFFA80707)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Detail Resto",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 300,
            // Use Image.network if imagePath is a URL from Firestore
            child:
                restaurant.imagePath.startsWith('http')
                    ? Image.network(restaurant.imagePath, fit: BoxFit.fill)
                    : Image.asset(restaurant.imagePath, fit: BoxFit.fill),
          ),
          Scroll(context),
        ],
      ),
    );
  }

  Widget Scroll(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 1.0,
      minChildSize: 0.75,
      builder: (context, ScrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 5, width: 35, color: Colors.black12),
                    ],
                  ),
                ),
                Text(
                  restaurant.name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.restaurant_menu_rounded,
                      color: Colors.black54,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      restaurant.category,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.black54, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      restaurant.time,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.black54,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        FutureBuilder<String>(
                          future: _openStreetMapService
                              .getAddressFromCoordinates(
                                restaurant.latitude,
                                restaurant.longitude,
                              ),
                          builder: (context, snapshot) {
                            String address = 'Fetching address...';
                            if (snapshot.hasData) {
                              address = snapshot.data!;
                            } else if (snapshot.hasError) {
                              address = 'Error fetching address';
                            }
                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.65,
                              ),
                              child: Text(
                                address,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    // Rating box
                    _buildRatingBox(restaurant.rating, restaurant.reviews),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE52020), Color(0xFFA80707)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      TambahUlasanPage(restaurant: restaurant),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fixedSize: const Size(122, 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7.5,
                            vertical: 5,
                          ),
                        ),
                        icon: Icon(Icons.edit, color: Colors.white, size: 15),
                        label: Text(
                          "Tambah ulasan",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        fixedSize: const Size(122, 40),
                        side: const BorderSide(color: Colors.transparent),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7.5,
                          vertical: 5,
                        ),
                      ),
                      icon: Icon(Icons.bookmark, color: Colors.black, size: 15),
                      label: Text(
                        "Simpan Tempat",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        fixedSize: const Size(122, 40),
                        side: const BorderSide(color: Colors.transparent),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7.5,
                          vertical: 5,
                        ),
                      ),
                      icon: Icon(
                        Icons.directions,
                        color: Colors.black,
                        size: 15,
                      ),
                      label: Text(
                        "Dapatkan arah",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Lokasi",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(
                        restaurant.latitude,
                        restaurant.longitude,
                      ),
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.makango',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              restaurant.latitude,
                              restaurant.longitude,
                            ),
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.location_pin,
                              color: Color(0xFFA80707),
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Ulasan",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Daftar Ulasan dari Firestore
                StreamBuilder<QuerySnapshot>(
                  stream:
                      _firestore
                          .collection('Review')
                          .where('restaurantId', isEqualTo: restaurant.id)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Belum ada ulasan untuk restoran ini.',
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    }

                    final reviews = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 10, bottom: 20),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final reviewData =
                            reviews[index].data() as Map<String, dynamic>;
                        final reviewId =
                            reviews[index].id; // Ambil reviewId untuk navigasi
                        final userId = reviewData['userId'] as String;
                        final photoUrls =
                            reviewData['photoUrls'] as List<dynamic>? ?? [];
                        final description =
                            reviewData['description'] as String? ??
                            'No description';
                        final foodRating =
                            reviewData['foodRating'] as int? ?? 0;
                        final serviceRating =
                            reviewData['serviceRating'] as int? ?? 0;
                        final ambianceRating =
                            reviewData['ambianceRating'] as int? ?? 0;
                        final timestamp = reviewData['createdAt'] as Timestamp?;
                        final likes = reviewData['likes'] as int? ?? 0;

                        // Format tanggal
                        String formattedDate = 'Unknown date';
                        if (timestamp != null) {
                          final date = timestamp.toDate();
                          formattedDate = DateFormat(
                            'dd MMM yyyy',
                          ).format(date);
                        }

                        return FutureBuilder<DocumentSnapshot>(
                          future:
                              _firestore.collection('User').doc(userId).get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (userSnapshot.hasError) {
                              return Center(
                                child: Text('Error loading user data'),
                              );
                            }
                            if (!userSnapshot.hasData ||
                                !userSnapshot.data!.exists) {
                              return SizedBox.shrink();
                            }

                            final userData =
                                userSnapshot.data!.data()
                                    as Map<String, dynamic>;
                            final username =
                                userData['name'] as String? ?? 'Unknown';
                            final avatarUrl =
                                userData['avatarUrl'] as String? ??
                                'assets/ex_profile.png';
                            final userReviews =
                                userData['reviewCount'] as int? ?? 0;
                            final userSavedPlaces =
                                userData['savedPlacesCount'] as int? ?? 0;
                            final userLevel = userData['level'] as int? ?? 1;

                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                bottom: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Info Pengguna
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            avatarUrl.startsWith('http')
                                                ? NetworkImage(avatarUrl)
                                                : AssetImage(avatarUrl)
                                                    as ImageProvider,
                                      ),
                                      SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                username,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '$userReviews Ulasan • $userSavedPlaces Daftar Tempat',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'Level $userLevel',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  // Rating (Satu baris dengan background linear pada bintang dan angka)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Makanan',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFE52020),
                                              Color(0xFFA80707),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow[700],
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '$foodRating',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '•',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Pelayanan',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFE52020),
                                              Color(0xFFA80707),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow[700],
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '$serviceRating',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '•',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Suasana',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFE52020),
                                              Color(0xFFA80707),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow[700],
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '$ambianceRating',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 16),
                                  // Deskripsi
                                  Text(
                                    description,
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  SizedBox(height: 8),
                                  // Teks "Lebih banyak" dengan navigasi ke DetailUlasanPage
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => DetailUlasanPage(
                                                reviewId: reviewId,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Lebih banyak',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.red,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.red,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  // Foto
                                  if (photoUrls.isNotEmpty)
                                    SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: photoUrls.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8.0,
                                            ),
                                            child: Image.network(
                                              photoUrls[index],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Image.asset(
                                                    'assets/sample_food.png',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  SizedBox(height: 8),
                                  // Tanggal
                                  Text(
                                    formattedDate,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Color(0xFFA80707),
                                        size: 20,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '$likes',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingBox(double rating, int reviews) {
    return Container(
      width: 70,
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
