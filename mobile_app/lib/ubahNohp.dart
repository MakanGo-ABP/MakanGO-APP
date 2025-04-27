import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPhonePage extends StatefulWidget {
  final String initialPhone;

  const EditPhonePage({super.key, required this.initialPhone});

  @override
  _EditPhonePageState createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    String phoneNumber = _phoneController.text.trim();

    // Validasi: pastikan input hanya berisi angka
    if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nomor HP hanya boleh berisi angka.')),
      );
      return;
    }

    // Validasi panjang nomor HP (10-13 digit)
    if (phoneNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nomor HP minimal harus 10 digit.')),
      );
      return;
    }
    if (phoneNumber.length > 13) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Nomor HP maksimal 13 digit.')));
      return;
    }

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
        await userDocRef.update({'phoneNumber': phoneNumber});
      } else {
        await userDocRef.set({
          'phoneNumber': phoneNumber,
        }, SetOptions(merge: true));
      }
      Navigator.pop(context, phoneNumber);
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
          "Ubah Nomor HP",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nomor Hp",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              maxLines: 1,
              maxLength: 13, // Batasi maksimal 13 digit
              keyboardType: TextInputType.phone, // Keyboard hanya angka
              decoration: InputDecoration(
                hintText: "Masukkan nomor HP baru",
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                counterText: "${_phoneController.text.length}/13",
                counterStyle: TextStyle(fontSize: 12, color: Colors.grey),
                suffixIcon:
                    _phoneController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _phoneController.clear();
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
        await _saveChanges();
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
