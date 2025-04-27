import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:makango/main.dart';

class LevelPage extends StatelessWidget {
  const LevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: const Color(0xFFA80707)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "MakanGo Level",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(),
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage("assets/ex_profile.png"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildXPBar(),
              const SizedBox(height: 20),
              Scroll(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildXPBar() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/logo_bronze.png"),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Level 1 • 0 XP",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => LevelPage(),
                  //   ), // Ganti NextPage dengan tujuan
                  // );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE52020), Color(0xFFA80707)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "10 XP ke Level 2",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.1,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFA80707),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Scroll(context),
        ],
      ),
    );
  }

  Scroll(BuildContext context) {
    return Container(
      width:
          MediaQuery.of(
            context,
          ).size.width, // Set width to the full screen width
      height: MediaQuery.of(context).size.height * 0.75, // 75% of screen height
      // width: MediaQuery.of(context).size.width * 1, // Fit the screen width
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            blurRadius: 10, // Blur radius
            offset: const Offset(0, -4), // Shadow offset (top shadow)
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
      ), // Remove side margins to make it flush
      padding: const EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
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
            Center(child: Image.asset("assets/empty.png")),
            const SizedBox(height: 5),
            Center(
              child: Text(
                "Riwayat Anda kosong!",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Anda belum memiliki ulasan, mulailah membuatnya",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            // Row(
            //   children: [
            //     Icon(Icons.restaurant_menu_rounded, color: Colors.black54, size: 16),
            //     const SizedBox(width: 5),
            //     Text(
            //       restaurant.category,
            //       style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 10),
            // Row(
            //   children: [
            //     Icon(Icons.access_time, color: Colors.black54, size: 16),
            //     const SizedBox(width: 5),
            //     Text(
            //       restaurant.time,
            //       style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 2),
            // Row(
            //   children: [
            //     Icon(Icons.location_on_outlined, color: Colors.black54, size: 16),
            //     const SizedBox(width: 5),
            //     ConstrainedBox(
            //       constraints: BoxConstraints(
            //         maxWidth: MediaQuery.of(context).size.width * 0.65,
            //       ),
            //       child: Text(
            //         restaurant.address,
            //         style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 20),
            // Text(
            //   "Ulasan",
            //   style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
