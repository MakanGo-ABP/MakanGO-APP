import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditNamePage extends StatefulWidget {
  final String initialName;

  const EditNamePage({super.key, required this.initialName});

  @override
  _EditNamePageState createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
        // Jika dokumen ada, lakukan update
        await userDocRef.update({'name': _nameController.text.trim()});
      } else {
        // Jika dokumen tidak ada, buat dokumen baru
        await userDocRef.set({
          'name': _nameController.text.trim(),
          'email': user.email ?? '',
        }, SetOptions(merge: true));
      }
      Navigator.pop(context, _nameController.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan perubahan: $e')));
    }
  }

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
          "Ubah Nama",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pakai nama asli untuk memudahkan verifikasi. Nama akan tampil di beberapa halaman.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Nama",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),

            TextField(
              controller: _nameController,
              maxLines: 1,
              maxLength: 50,
              decoration: InputDecoration(
                hintText: "Masukkan nama",
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                counterText: "${_nameController.text.length}/50",
                counterStyle: TextStyle(fontSize: 12, color: Colors.grey),
                suffixIcon:
                    _nameController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _nameController.clear();
                            });
                          },
                        )
                        : null,
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
            SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Tombol Simpan
  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () async {
        await _saveChanges(); // Panggil fungsi async dengan await
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE52020), Color(0xFFA80707)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            "Simpan",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
