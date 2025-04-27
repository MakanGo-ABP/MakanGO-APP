import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi untuk mengambil data pengguna dari Firestore
  Future<Map<String, String>> loadUserData() async {
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
        };
      } else {
        return {
          'name': 'Nama Tidak Ditemukan',
          'username': '@username',
          'phoneNumber': '',
          'email': '',
          'gender': '',
          'avatarUrl': 'assets/ex_profile.png',
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
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi.');
      }

      Map<String, dynamic> updatedData = {};
      if (name != null) updatedData['name'] = name;
      if (username != null) {
        // Hapus @ dari username jika ada (karena @ hanya untuk tampilan)
        updatedData['username'] =
            username.startsWith('@') ? username.substring(1) : username;
      }
      if (phoneNumber != null) updatedData['phoneNumber'] = phoneNumber;
      if (gender != null) updatedData['gender'] = gender;
      if (avatarUrl != null) updatedData['avatarUrl'] = avatarUrl;

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
}
