import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'model/restaurant_model.dart';
import 'tambahulasan.dart';
import 'package:mobile_app/services/openstreetmap_service.dart';

class RestaurantDetailPage extends StatelessWidget {
  final Restaurant restaurant;
  final OpenStreetMapService _openStreetMapService = OpenStreetMapService();

  RestaurantDetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Detail Resto'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            color: Colors.red,
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
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Ulasan",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
