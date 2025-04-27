import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/buatPlaceList_page.dart';
import 'package:mobile_app/model/place_list_model.dart';
import 'package:mobile_app/services/place_list_service.dart';
import 'package:mobile_app/tambahtempat_page.dart';

class DaftartempatPage extends StatefulWidget {
  const DaftartempatPage({super.key});

  @override
  _DaftartempatPageState createState() => _DaftartempatPageState();
}

class _DaftartempatPageState extends State<DaftartempatPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isPublic = true;
  final PlaceListService _placeListService = PlaceListService();
  PlaceList? _tempPlaceList;

  @override
  void initState() {
    super.initState();
    _initializeTempList();
  }

  Future<void> _initializeTempList() async {
    if (FirebaseAuth.instance.currentUser == null) {
      print('No authenticated user, signing in anonymously');
      try {
        await FirebaseAuth.instance.signInAnonymously();
      } catch (e) {
        print('Error signing in anonymously: $e');
        return;
      }
    }
    try {
      final tempList = await _placeListService.createTemporaryPlaceList();
      print('Temporary place list initialized: ${tempList.id}');
      setState(() {
        _tempPlaceList = tempList;
      });
    } catch (e) {
      print('Error initializing temporary list: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat daftar sementara: $e')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    // Delete temporary list if not saved
    if (_tempPlaceList != null && _titleController.text.isEmpty) {
      print('Disposing, deleting temporary list: ${_tempPlaceList!.id}');
      _placeListService.deletePlaceList(_tempPlaceList!.id);
    }
    super.dispose();
  }

  void _saveList() async {
    if (_titleController.text.isEmpty) {
      print('Title is empty, cannot save');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Judul tidak boleh kosong')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No authenticated user');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda harus login untuk membuat daftar')),
      );
      return;
    }

    if (_tempPlaceList == null) {
      print('Temporary place list is null');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Daftar sementara belum siap')),
      );
      return;
    }

    print('Simpan button pressed for place list: ${_tempPlaceList!.id}');
    try {
      // Fetch the latest PlaceList from Firestore to preserve restaurantIds
      final doc = await FirebaseFirestore.instance
          .collection('PlaceLists')
          .doc(_tempPlaceList!.id)
          .get();
      if (!doc.exists) {
        print('Place list ${_tempPlaceList!.id} not found in Firestore');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Daftar tidak ditemukan')),
        );
        return;
      }
      final updatedPlaceList = PlaceList.fromFirestore(doc);
      print('Fetched PlaceList with restaurantIds: ${updatedPlaceList.restaurantIds}');

      // Create PlaceList with user inputs and Firestore restaurantIds
      final placeList = PlaceList(
        id: _tempPlaceList!.id,
        title: _titleController.text,
        notes: _notesController.text,
        isPublic: _isPublic,
        creatorUid: user.uid,
        restaurantIds: updatedPlaceList.restaurantIds, // Preserve Firestore restaurantIds
        createdAt: _tempPlaceList!.createdAt,
      );

      await _placeListService.savePlaceList(placeList);
      print('Navigating to BuatplacelistPage after saving');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BuatplacelistPage()),
      );
      _showSuccessPopup(context);
    } catch (e) {
      print('Error saving list: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_tempPlaceList == null) {
      print('Waiting for temporary list to initialize');
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: const Color(0xFFA80707)),
          onPressed: () => _showCancelPopup(context),
        ),
        title: Text(
          "Buat Daftar Tempat",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _saveList,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE52020), Color(0xFFA80707)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                alignment: Alignment.center,
                constraints: BoxConstraints(minWidth: 80, maxHeight: 45),
                child: Text(
                  "Simpan",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Buat Daftar Tempat Baru",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Buatlah daftar perjalanan kuliner Anda dan bagikan kepada orang-orang terkasih.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Judul Daftar",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Rencana jalan-jalan",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                counterText: "${_titleController.text.length}/30",
              ),
              maxLength: 30,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Tetapkan Daftar Tempat ke Publik"),
                    Text(
                      "Siapa pun dapat menemukan & melihat daftar tempat ini",
                      style: TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                  ],
                ),
                Switch(
                  value: _isPublic,
                  onChanged: (value) {
                    setState(() {
                      _isPublic = value;
                    });
                  },
                  activeColor: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Tambahkan Catatan",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: "Tambah catatan",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('PlaceLists')
                  .doc(_tempPlaceList!.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print('No data for temporary list: ${_tempPlaceList!.id}');
                  return const SizedBox.shrink();
                }
                final placeList = PlaceList.fromFirestore(snapshot.data!);
                print('Temporary list restaurantIds: ${placeList.restaurantIds}');
                return Row(
                  children: [
                    const SizedBox(width: 7),
                    Image.asset('assets/logo_lokasi_v2.png', height: 20),
                    const SizedBox(width: 8),
                    Text(
                      "${placeList.restaurantIds.length} Tempat",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('PlaceLists')
                  .doc(_tempPlaceList!.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print('No data for temporary list: ${_tempPlaceList!.id}');
                  return const Center(child: CircularProgressIndicator());
                }
                final placeList = PlaceList.fromFirestore(snapshot.data!);
                if (placeList.restaurantIds.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Image.asset('assets/empty_state.png', height: 200),
                        const SizedBox(height: 10),
                        const Text(
                          "Daftar Tempat Anda kosong!",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Mulai menambahkan tempat ke Daftar Tempat ini",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                }
                return Container(); // Placeholder: Add restaurant list if needed
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 130),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE52020), Color(0xFFA80707)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  print('Navigating to TambahtempatPage for list: ${_tempPlaceList!.id}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TambahtempatPage(
                        placeListId: _tempPlaceList!.id,
                      ),
                    ),
                  ).then((value) {
                    if (value == true) {
                      print('Restaurants added, refreshing UI');
                      setState(() {});
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Tambah Tempat",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showSuccessPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 5,
                width: 35,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Image.asset('assets/success.png', height: 150),
              const SizedBox(height: 16),
              Text(
                "Anda berhasil membuat Daftar Tempat Baru!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close popup
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA80707),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  child: Text(
                    "Ok",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCancelPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/cancel.png', height: 150),
              const SizedBox(height: 16),
              Text(
                "Anda yakin ingin kembali?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Perubahan Anda tidak akan disimpan jika Anda menutupnya sekarang",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      print('Canceling, navigating to BuatplacelistPage');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuatplacelistPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFA80707)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        "Tutup",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA80707),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA80707),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        "Lanjut Mengedit",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}