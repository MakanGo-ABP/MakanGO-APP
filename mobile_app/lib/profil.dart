import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/pengaturan.dart';
import 'package:mobile_app/level_page.dart';
import 'package:mobile_app/ubahProfile.dart';
import 'package:mobile_app/services/profile_service.dart';
import 'package:mobile_app/services/place_list_service.dart'; // Import PlaceListService
import 'package:mobile_app/model/place_list_model.dart'; // Import PlaceList model

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool isReviewTabActive = true; // Tab default = "Ulasan"
  String _name = '';
  String _username = '';
  Map<String, dynamic> _userData = {};
  final ProfileService _profileService = ProfileService();
  final PlaceListService _placeListService = PlaceListService(); // Initialize PlaceListService
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userData = await _profileService.loadUserData();
      setState(() {
        _userData = userData;
        _name = userData['name']!;
        _username = userData['username']!;
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 10),
          _buildXPBar(),
          const SizedBox(height: 10),
          _buildTabs(),
          Expanded(
            child: isReviewTabActive ? _buildEmptyState() : _buildPlaceList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE52020), Color(0xFFA80707)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(
                  _userData['avatarUrl'] ?? "assets/ex_profile.png",
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UbahProfilPage()),
                    ).then((value) {
                      _loadUserData();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.redAccent, width: 2),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _username,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _name,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildXPBar() {
    int xp = _userData['xp'] ?? 0;
    int level = _userData['level'] ?? 1;
    String levelName;
    String levelIcon;
    int xpForNextLevel;
    double progress;

    if (xp == 0) {
      progress = 0.0;
    } else {
      if (level == 1) {
        xpForNextLevel = 50;
        progress = xp / 50.0;
      } else if (level == 2) {
        xpForNextLevel = 100;
        progress = (xp - 50) / 50.0;
      } else {
        xpForNextLevel = xp;
        progress = 1.0;
      }
    }

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
      levelIcon = "assets/logo_gold.png";
      xpForNextLevel = xp;
    }

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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LevelPage()),
                  ).then((value) {
                    _loadUserData();
                  });
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
                        level < 3
                            ? "${xpForNextLevel - xp} XP ke Level ${level + 1}"
                            : "Max Level",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.navigate_next_outlined,
                        color: Colors.white,
                        size: 16,
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
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFA80707),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTabItem(
          "Ulasan",
          isActive: isReviewTabActive,
          onTap: () {
            setState(() {
              isReviewTabActive = true;
            });
          },
        ),
        _buildTabItem(
          "Daftar Tempat",
          isActive: !isReviewTabActive,
          onTap: () {
            setState(() {
              isReviewTabActive = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTabItem(
    String label, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              color: isActive ? const Color(0xFFA80707) : Colors.black,
            ),
          ),
          Container(
            height: 2,
            width: isActive ? (label == "Daftar Tempat" ? 100 : 50) : 50,
            color: isActive ? const Color(0xFFA80707) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/logo_empty.png", width: 150),
          const SizedBox(height: 10),
          Text(
            "Ulasan Anda kosong!",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            "Anda belum memiliki ulasan, mulailah membuatnya",
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceList() {
    return StreamBuilder<List<PlaceList>>(
      stream: _placeListService.getPlaceLists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFA80707)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Gagal memuat daftar tempat: ${snapshot.error}',
              style: GoogleFonts.poppins(),
            ),
          );
        }

        final placeLists = snapshot.data ?? [];

        if (placeLists.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/logo_empty.png", width: 150),
                const SizedBox(height: 10),
                Text(
                  "Daftar Tempat Anda kosong!",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Mulai buat daftar tempat Anda sekarang",
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Color(0xFFA80707), size: 25),
                  const SizedBox(width: 5),
                  Text(
                    "${placeLists.length} Daftar Tempat",
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: placeLists.length,
                  itemBuilder: (context, index) {
                    final placeList = placeLists[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFE52020), Color(0xFFA80707)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.white,
                                    size: 90,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            placeList.isPublic
                                                ? Icons.public
                                                : Icons.lock,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            placeList.isPublic
                                                ? "Daftar Tempat Publik"
                                                : "Daftar Tempat Pribadi",
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        placeList.title,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundImage: AssetImage(
                                              _userData['avatarUrl'] ??
                                                  "assets/ex_profile.png",
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            _name,
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_pin,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${placeList.restaurantIds.length} tempat",
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}