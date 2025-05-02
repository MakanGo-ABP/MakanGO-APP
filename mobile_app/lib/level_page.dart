import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/services/auth.services.dart';
import 'package:mobile_app/services/profile_service.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({super.key});

  @override
  _LevelPageState createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Color(0xFFA80707)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Level",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: Text(
            "Silakan login untuk melihat level Anda",
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('User').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator(color: Color(0xFFA80707))),
          );
        }

        if (snapshot.hasError) {
          print('LevelPage StreamBuilder error: ${snapshot.error}');
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
                style: GoogleFonts.poppins(),
              ),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          print('No user data found for UID: ${user.uid}, initializing...');
          _profileService.initializeUserData(); // Ensure user data is initialized
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'Menginisialisasi data pengguna...',
                style: GoogleFonts.poppins(),
              ),
            ),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        userData['xp'] = (userData['xp'] as int?) ?? 0; // Fallback for missing xp
        userData['level'] = (userData['level'] as int?) ?? 1; // Fallback for missing level
        print('LevelPage StreamBuilder updated: xp=${userData['xp']}, level=${userData['level']}');

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Color(0xFFA80707)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Level",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Level Anda",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                _buildXPBar(userData),
                const SizedBox(height: 20),
                Text(
                  "Cara Mendapatkan XP",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "• Dapatkan 5 XP setiap kali ulasan Anda disukai oleh pengguna lain.\n"
                  "• Naik ke Level Silver (51–100 XP) dan Gold (101+ XP) untuk menunjukkan prestasi Anda!",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildXPBar(Map<String, dynamic> userData) {
    int xp = userData['xp'] as int;
    int level = userData['level'] as int;
    String levelName;
    String levelIcon;
    int xpForNextLevel;
    double progress;

    // Calculate level and progress
    if (xp <= 50) {
      level = 1;
      levelName = "Bronze";
      levelIcon = "assets/logo_bronze.png";
      xpForNextLevel = 50;
      progress = xp / 50.0;
    } else if (xp <= 100) {
      level = 2;
      levelName = "Silver";
      levelIcon = "assets/logo_silver.png";
      xpForNextLevel = 100;
      progress = (xp - 50) / 50.0;
    } else {
      level = 3;
      levelName = "Gold";
      levelIcon = "assets/logo_gold.png";
      xpForNextLevel = xp; // No next level
      progress = 1.0;
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
                child: Text(
                  level < 3
                      ? "${xpForNextLevel - xp} XP ke Level ${level + 1}"
                      : "Max Level",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
          Text(
            "Status: $levelName",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}