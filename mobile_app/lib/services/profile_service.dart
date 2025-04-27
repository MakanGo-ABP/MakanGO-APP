import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fungsi untuk menginisialisasi data pengguna baru
  Future<void> initializeUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi.');
      }

      DocumentReference userDocRef = _firestore
          .collection('User')
          .doc(user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // Jika dokumen pengguna belum ada, buat data awal
        await userDocRef.set({
          'name': user.displayName ?? 'Pengguna Baru',
          'username': '',
          'phoneNumber': '',
          'email': user.email ?? '',
          'gender': '',
          'avatarUrl': 'assets/ex_profile.png',
          'xp': 0,
          'level': 1,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Gagal menginisialisasi data pengguna: $e');
    }
  }

  // Fungsi untuk mengambil data pengguna dari Firestore
  Future<Map<String, dynamic>> loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return {
          'name': 'Nama Tidak Ditemukan',
          'username': '@username',
          'phoneNumber': '',
          'email': '',
          'gender': '',
          'avatarUrl': 'assets/ex_profile.png',
          'xp': 0,
          'level': 1,
        };
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return {
          'name': userData['name'] ?? 'Nama Tidak Ditemukan',
          'username':
              userData['username'] != null && userData['username'].isNotEmpty
                  ? '@${userData['username']}'
                  : '@username',
          'phoneNumber': userData['phoneNumber'] ?? '',
          'email': userData['email'] ?? '',
          'gender': userData['gender'] ?? '',
          'avatarUrl': userData['avatarUrl'] ?? 'assets/ex_profile.png',
          'xp': userData['xp'] ?? 0,
          'level': userData['level'] ?? 1,
        };
      } else {
        // Jika dokumen tidak ada, inisialisasi data pengguna baru
        await initializeUserData();
        return {
          'name': 'Pengguna Baru',
          'username': '@username',
          'phoneNumber': '',
          'email': user.email ?? '',
          'gender': '',
          'avatarUrl': 'assets/ex_profile.png',
          'xp': 0,
          'level': 1,
        };
      }
    } catch (e) {
      throw Exception('Gagal memuat data pengguna: $e');
    }
  }

  // Fungsi untuk menyimpan perubahan data pengguna ke Firestore
  Future<void> updateUserData({
    String? name,
    String? username,
    String? phoneNumber,
    String? gender,
    String? avatarUrl,
    int? xp,
    int? level,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi.');
      }

      Map<String, dynamic> updatedData = {};
      if (name != null) updatedData['name'] = name;
      if (username != null) {
        updatedData['username'] =
            username.startsWith('@') ? username.substring(1) : username;
      }
      if (phoneNumber != null) updatedData['phoneNumber'] = phoneNumber;
      if (gender != null) updatedData['gender'] = gender;
      if (avatarUrl != null) updatedData['avatarUrl'] = avatarUrl;
      if (xp != null) updatedData['xp'] = xp;
      if (level != null) updatedData['level'] = level;

      if (updatedData.isNotEmpty) {
        await _firestore.collection('User').doc(user.uid).update(updatedData);
      }
    } catch (e) {
      throw Exception('Gagal menyimpan perubahan: $e');
    }
  }

  // Fungsi untuk mengambil nama pengguna
  Future<String> getName() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return 'Nama Tidak Ditemukan';
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return userData['name'] ?? 'Nama Tidak Ditemukan';
      } else {
        return 'Nama Tidak Ditemukan';
      }
    } catch (e) {
      throw Exception('Gagal mengambil nama pengguna: $e');
    }
  }

  // Fungsi untuk mengunggah foto profil ke Firebase Storage dan memperbarui URL di Firestore
  Future<String> uploadProfilePicture(File imageFile) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi.');
      }

      final storageRef = _storage.ref().child(
        'profile_pictures/${user.uid}.jpg',
      );
      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();
      await updateUserData(avatarUrl: downloadUrl);
      return downloadUrl;
    } catch (e) {
      throw Exception('Gagal mengunggah foto profil: $e');
    }
  }

  // Fungsi untuk menambahkan ulasan dan menghitung XP
  Future<void> addReview({
    required String restaurantName,
    required String category,
    required String time,
    required String address,
    required String comment,
    required bool hasImage,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi.');
      }

      // Tambahkan ulasan ke subkoleksi Reviews
      await _firestore
          .collection('User')
          .doc(user.uid)
          .collection('Reviews')
          .add({
            'restaurantName': restaurantName,
            'category': category,
            'time': time,
            'address': address,
            'comment': comment,
            'hasImage': hasImage,
            'timestamp': FieldValue.serverTimestamp(),
          });

      // Hitung XP baru
      int xpToAdd = hasImage ? 10 : 5;
      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(user.uid).get();
      int currentXp = (userDoc.data() as Map<String, dynamic>)['xp'] ?? 0;
      int newXp = currentXp + xpToAdd;

      // Hitung level baru
      int newLevel;
      if (newXp < 50) {
        newLevel = 1; // Bronze
      } else if (newXp < 100) {
        newLevel = 2; // Silver
      } else {
        newLevel = 3; // Gold
      }

      // Perbarui XP dan level di Firestore
      await updateUserData(xp: newXp, level: newLevel);
    } catch (e) {
      throw Exception('Gagal menambahkan ulasan: $e');
    }
  }

  // Fungsi untuk mengambil riwayat ulasan
  Future<List<Map<String, dynamic>>> getReviews() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return [];
      }

      QuerySnapshot reviewsSnapshot =
          await _firestore
              .collection('User')
              .doc(user.uid)
              .collection('Reviews')
              .orderBy('timestamp', descending: true)
              .get();

      return reviewsSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'restaurantName': data['restaurantName'] ?? '',
          'category': data['category'] ?? '',
          'time': data['time'] ?? '',
          'address': data['address'] ?? '',
          'comment': data['comment'] ?? '',
          'hasImage': data['hasImage'] ?? false,
        };
      }).toList();
    } catch (e) {
      throw Exception('Gagal memuat riwayat ulasan: $e');
    }
  }
}
