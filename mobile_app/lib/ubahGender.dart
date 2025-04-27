import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditGenderPage extends StatefulWidget {
  final String initialGender;

  const EditGenderPage({super.key, required this.initialGender});

  @override
  _EditGenderPageState createState() => _EditGenderPageState();
}

class _EditGenderPageState extends State<EditGenderPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedGender = '';
  bool _isEditable = true; // Untuk menentukan apakah tombol Simpan aktif

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialGender;
    _checkIfGenderAlreadySet(); // Periksa apakah gender sudah pernah diatur
  }

  // Periksa apakah gender sudah pernah diatur sebelumnya
  Future<void> _checkIfGenderAlreadySet() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        // Jika field 'gender' sudah ada dan bukan string kosong, nonaktifkan tombol
        if (userData.containsKey('gender') &&
            userData['gender'] != null &&
            userData['gender'] != '') {
          setState(() {
            _isEditable = false;
          });
        }
      }
    }
  }

  Future<void> _saveChanges() async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pengguna tidak terautentikasi. Silakan login kembali.',
          ),
        ),
      );
      return;
    }

    try {
      DocumentReference userDocRef = _firestore
          .collection('User')
          .doc(user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        await userDocRef.update({'gender': _selectedGender});
      } else {
        await userDocRef.set({
          'gender': _selectedGender,
          'email': user.email ?? '',
        }, SetOptions(merge: true));
      }
      Navigator.pop(context, _selectedGender);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan perubahan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Ubah Jenis Kelamin",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Pilih Jenis Kelamin",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 4),
            Center(
              child: Text(
                "Jenis kelamin hanya dapat diatur sekali.",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGenderOption(
                  gender: 'Laki-laki',
                  icon: Icons.male_outlined,
                  isSelected: _selectedGender == 'Laki-laki',
                  onTap:
                      _isEditable
                          ? () {
                            setState(() {
                              _selectedGender = 'Laki-laki';
                            });
                          }
                          : null, // Nonaktifkan onTap jika sudah pernah diatur
                ),
                _buildGenderOption(
                  gender: 'Perempuan',
                  icon: Icons.female,
                  isSelected: _selectedGender == 'Perempuan',
                  onTap:
                      _isEditable
                          ? () {
                            setState(() {
                              _selectedGender = 'Perempuan';
                            });
                          }
                          : null, // Nonaktifkan onTap jika sudah pernah diatur
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Widget untuk opsi jenis kelamin
  Widget _buildGenderOption({
    required String gender,
    required IconData icon,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: isSelected ? Colors.green : Colors.grey.shade600,
                ),
                if (isSelected)
                  Positioned(
                    bottom: 0,
                    right: 3,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 16),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            gender,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // Tombol Simpan
  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap:
          _isEditable
              ? () async {
                await _saveChanges();
              }
              : null, // Nonaktifkan onTap jika sudah pernah diatur
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient:
              _isEditable
                  ? const LinearGradient(
                    colors: [Color(0xFFE52020), Color(0xFFA80707)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null, // Hilangkan gradient jika tombol dinonaktifkan
          color:
              _isEditable
                  ? null
                  : Colors.grey.shade300, // Warna abu-abu jika dinonaktifkan
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            "Simpan",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _isEditable ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
