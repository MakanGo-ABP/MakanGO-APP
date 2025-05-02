import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Initialize new user data
  Future<void> initializeUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi.');
      }

      DocumentReference userDocRef = _firestore.collection('User').doc(user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // Create initial user data if document doesn't exist
        await userDocRef.set({
          'name': user.displayName ?? 'Pengguna Baru',
          'username': '',
          'phoneNumber': '',
          'email': user.email ?? '',
          'gender': '',
          'avatarUrl': 'assets/ex_profile.png',
          'xp': 0,
          'level': 1,
          'jumlah_review': 0, // Add review count
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('Initialized new user ${user.uid}: xp=0, level=1, jumlah_review=0');
      } else {
        // Ensure existing users have xp, level, and jumlah_review
        Map<String, dynamic> updates = {};
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        if (!data.containsKey('xp')) {
          updates['xp'] = 0;
        }
        if (!data.containsKey('level')) {
          updates['level'] = 1;
        }
        if (!data.containsKey('jumlah_review')) {
          updates['jumlah_review'] = 0;
        }
        if (updates.isNotEmpty) {
          await userDocRef.update(updates);
          print('Updated existing user ${user.uid} with missing fields: $updates');
        }
      }
    } catch (e) {
      print('Error initializing user data: $e');
      throw Exception('Gagal menginisialisasi data pengguna: $e');
    }
  }

  // Load user data from Firestore
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
          'jumlah_review': 0,
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
          'jumlah_review': userData['jumlah_review'] ?? 0,
        };
      } else {
        // Initialize new user data if document doesn't exist
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
          'jumlah_review': 0,
        };
      }
    } catch (e) {
      print('Error loading user data: $e');
      throw Exception('Gagal memuat data pengguna: $e');
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData({
    String? name,
    String? username,
    String? phoneNumber,
    String? gender,
    String? avatarUrl,
    int? xp,
    int? level,
    int? jumlahReview,
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
      if (jumlahReview != null) updatedData['jumlah_review'] = jumlahReview;

      if (updatedData.isNotEmpty) {
        await _firestore.collection('User').doc(user.uid).update(updatedData);
        print('Updated user data for ${user.uid}: $updatedData');
      }
    } catch (e) {
      print('Error updating user data: $e');
      throw Exception('Gagal menyimpan perubahan: $e');
    }
  }

  // Get user's name
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
      print('Error getting user name: $e');
      throw Exception('Gagal mengambil nama pengguna: $e');
    }
  }

  // Upload profile picture to Firebase Storage and update URL in Firestore
  Future<String> uploadProfilePicture(File imageFile) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi.');
      }

      final storageRef =
          _storage.ref().child('profile_pictures/${user.uid}.jpg');
      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();
      await updateUserData(avatarUrl: downloadUrl);
      print('Uploaded profile picture for ${user.uid}: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      throw Exception('Gagal mengunggah foto profil: $e');
    }
  }

  // Update XP and level after an action (review or like)
  Future<void> updateUserXP({
    required String userId,
    required int xpToAdd,
  }) async {
    try {
      DocumentReference userRef = _firestore.collection('User').doc(userId);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot userDoc = await transaction.get(userRef);
        if (!userDoc.exists) {
          throw Exception('Pengguna tidak ditemukan.');
        }

        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        int currentXP = (data['xp'] as int?) ?? 0;
        int newXP = currentXP + xpToAdd;
        if (newXP < 0) newXP = 0; // Prevent negative XP

        // Calculate new level
        int newLevel;
        if (newXP <= 50) {
          newLevel = 1; // Bronze
        } else if (newXP <= 100) {
          newLevel = 2; // Silver
        } else {
          newLevel = 3; // Gold
        }

        // Update XP and level
        transaction.update(userRef, {
          'xp': newXP,
          'level': newLevel,
        });
        print('Updated XP for user $userId: newXP=$newXP, newLevel=$newLevel');
      });

      // Notify on level-up
      DocumentSnapshot updatedDoc = await userRef.get();
      Map<String, dynamic> updatedData = updatedDoc.data() as Map<String, dynamic>;
      int newLevel = updatedData['level'] ?? 1;
      int newXP = updatedData['xp'] ?? 0;
      if (newXP > 50 && newLevel == 2) {
        await userRef.collection('Notifications').add({
          'type': 'level_up',
          'message': 'Selamat! Kamu naik ke Level Silver!',
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
        print('Created level-up notification for user $userId: Level Silver');
      } else if (newXP > 100 && newLevel == 3) {
        await userRef.collection('Notifications').add({
          'type': 'level_up',
          'message': 'Selamat! Kamu naik ke Level Gold!',
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
        print('Created level-up notification for user $userId: Level Gold');
      }
    } catch (e) {
      print('Error updating user XP: $e');
      throw Exception('Gagal memperbarui XP pengguna: $e');
    }
  }

  // Fetch user reviews from Review collection
  Future<List<Map<String, dynamic>>> getReviews() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return [];
      }

      QuerySnapshot reviewsSnapshot = await _firestore
          .collection('Review')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> reviews = [];
      for (var doc in reviewsSnapshot.docs) {
        final reviewData = doc.data() as Map<String, dynamic>;
        DocumentSnapshot restaurantDoc = await _firestore
            .collection('Restaurant')
            .doc(reviewData['restaurantId'])
            .get();
        if (restaurantDoc.exists) {
          final restaurantData = restaurantDoc.data() as Map<String, dynamic>;
          reviews.add({
            'restaurantName': restaurantData['name'] ?? 'Unknown',
            'category': restaurantData['category'] ?? 'Unknown',
            'time': (reviewData['createdAt'] as Timestamp?)?.toDate().toString() ??
                'Unknown',
            'address': restaurantData['address'] ?? 'Unknown',
            'comment': reviewData['description'] ?? '',
          });
        }
      }
      print('Fetched ${reviews.length} reviews for user ${user.uid}');
      return reviews;
    } catch (e) {
      print('Error fetching reviews: $e');
      throw Exception('Gagal memuat riwayat ulasan: $e');
    }
  }
}