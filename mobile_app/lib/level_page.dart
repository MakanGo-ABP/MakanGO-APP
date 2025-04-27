import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/services/profile_service.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({super.key});

  @override
  _LevelPageState createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  final ProfileService _profileService = ProfileService();
  Map<String, dynamic> _userData = {};
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Pastikan data pengguna diinisialisasi
      await _profileService.initializeUserData();
      final userData = await _profileService.loadUserData();
      final reviews = await _profileService.getReviews();
      setState(() {
        _userData = userData;
        _reviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFA80707)),
        ),
      );
    }

    int xp = _userData['xp'] ?? 0;
    int level = _userData['level'] ?? 1;
    String levelName;
    String levelIcon;
    int xpForNextLevel;
    double progress;

    // Pastikan bar abu-abu penuh jika XP 0
    if (xp == 0) {
      progress = 0.0; // Bar akan penuh abu-abu
    } else {
      if (level == 1) {
        xpForNextLevel = 50;
        progress = xp / 50.0;
      } else if (level == 2) {
        xpForNextLevel = 100;
        progress = (xp - 50) / 50.0;
      } else {
        xpForNextLevel = xp;
        progress = 1.0; // Gold adalah level tertinggi
      }
    }

    // Tentukan level name dan ikon
    if (level == 1) {
      levelName = "Bronze";
      levelIcon = "assets/logo_bronze.png";
      xpForNextLevel = 50;
    } else if (level == 2) {
      levelName = "Silver";
      levelIcon = "assets/logo_silver.png";
      xpForNextLevel = 100;
    } else {
      levelName = "Gold";
      levelIcon =
          "assets/logo_gold.png"; // Ganti "red.png" dengan ikon gold yang sesuai
      xpForNextLevel = xp;
    }

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
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(
                      _userData['avatarUrl'] ?? "assets/ex_profile.png",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildXPBar(
                xp: xp,
                level: level,
                levelName: levelName,
                levelIcon: levelIcon,
                xpForNextLevel: xpForNextLevel,
                progress: progress.clamp(0.0, 1.0),
              ),
              const SizedBox(height: 20),
              Scroll(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildXPBar({
    required int xp,
    required int level,
    required String levelName,
    required String levelIcon,
    required int xpForNextLevel,
    required double progress,
  }) {
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
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(levelIcon),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Level $level • $xp XP",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
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
                      level < 3
                          ? "${xpForNextLevel - xp} XP ke Level ${level + 1}"
                          : "Max Level",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
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

  Widget Scroll(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0),
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
            if (_reviews.isEmpty)
              Column(
                children: [
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
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Riwayat Ulasan",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._reviews.map((review) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['restaurantName'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.restaurant_menu_rounded,
                                color: Colors.black54,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                review['category'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.black54,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                review['time'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.black54,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.65,
                                ),
                                child: Text(
                                  review['address'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Ulasan: ${review['comment']}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            review['hasImage']
                                ? "+10 XP (Dengan Gambar)"
                                : "+5 XP (Tanpa Gambar)",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA80707),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
