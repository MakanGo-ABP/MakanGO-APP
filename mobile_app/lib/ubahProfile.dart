import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ubahNama.dart';
import 'ubahUsername.dart';
import 'ubahNohp.dart';
// import 'edit_email_page.dart';
import 'ubahGender.dart';

class UbahProfilPage extends StatefulWidget {
  const UbahProfilPage({super.key});

  @override
  _UbahProfilPageState createState() => _UbahProfilPageState();
}

class _UbahProfilPageState extends State<UbahProfilPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _name = '';
  String _username = '';
  String _phone = '';
  String _email = '';
  String _gender = 'Perempuan';
  String _avatarUrl = 'assets/ex_profile.png';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Ambil data pengguna dari Firestore
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _name = userData['name'] ?? '';
          _username = userData['username'] ?? '';
          _phone = userData['phoneNumber'] ?? '';
          _email = userData['email'] ?? '';
          _gender = userData['gender'] ?? '';
          _avatarUrl = userData['avatarUrl'] ?? 'assets/ex_profile.png';
        });
      }
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
          "Ubah Profil",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto Profil
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _avatarUrl.startsWith('http')
                          ? NetworkImage(_avatarUrl)
                          : AssetImage(_avatarUrl) as ImageProvider,
                ),
              ],
            ),
            SizedBox(height: 8),
            // Teks "Ubah Foto Profil"
            GestureDetector(
              onTap: () {
                // TODO: Tambahkan fungsi untuk mengubah foto profil
              },
              child: Text(
                'Foto Profil',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA80707),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 32),
            // Bagian "Info Profil"
            Row(
              children: [
                Text(
                  'INFO PROFIL',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA80707),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.info_outline, color: Colors.grey[400]),
              ],
            ),
            SizedBox(height: 16),
            // Nama
            _buildProfileField(
              label: 'Nama',
              value: _name,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditNamePage(initialName: _name),
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _name = value;
                    });
                  }
                });
              },
            ),
            SizedBox(height: 16),
            // Username
            _buildProfileField(
              label: 'Username',
              value: _username,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            EditUsernamePage(initialUsername: _username),
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _username = value;
                    });
                  }
                });
              },
            ),
            SizedBox(height: 32),
            // Bagian "Info Pribadi"
            Row(
              children: [
                Text(
                  'INFO PRIBADI',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA80707),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.info_outline, color: Colors.grey[400]),
              ],
            ),
            SizedBox(height: 16),
            // Nomor Hp
            _buildProfileField(
              label: 'Nomor Hp',
              value: _phone,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPhonePage(initialPhone: _phone),
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _phone = value;
                    });
                  }
                });
              },
            ),
            SizedBox(height: 16),
            // Email
            _buildNonEditableField(label: 'Email', value: _email),
            SizedBox(height: 16),
            // Jenis Kelamin
            _buildProfileField(
              label: 'Jenis Kelamin',
              value: _gender,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => EditGenderPage(initialGender: _gender),
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _gender = value;
                    });
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk field yang hanya menampilkan data
  Widget _buildProfileField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.isEmpty ? 'Belum diisi' : value,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildNonEditableField({required String label, required String value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
      ),
      Text(
        value.isEmpty ? 'Belum diisi' : value,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
      ),
    ],
  );
}
