import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makango/main.dart';

class TambahRestoPage extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          "Tambah Resto",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () => _showSuccessPopup(context),
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
                  borderRadius: BorderRadius.circular(
                    50,
                  ), // Bigger border radius
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ), // Kurangi padding
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  minWidth: 90,
                  minHeight: 50,
                ), // Perkecil ukuran minimal
                child: Text(
                  "Simpan",
                  style: GoogleFonts.poppins(
                    fontSize: 11, // Perkecil ukuran teks
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      "Tambah Resto Baru",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Buatlah daftar resto yang belum terdaftar dan bagikan kepada orang-orang terkasih.",
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
              _buildTextField(
                "Nama Resto",
                "Masukkan nama resto...",
                namaController,
                30,
              ),
              _buildTextField(
                "Deskripsi Resto",
                "Tuliskan deskripsi resto...",
                deskripsiController,
                30,
              ),
              _buildTimePickerField(context, "Jam Buka Resto"),
              _buildTimePickerField(context, "Jam Tutup Resto"),
              _buildTextField(
                "Alamat Resto",
                "Tuliskan alamat resto...",
                alamatController,
                50,
              ),
              _buildFileUploadSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    int maxLength,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          ),
          maxLength: maxLength,
          buildCounter: (
            BuildContext context, {
            int? currentLength,
            bool? isFocused,
            int? maxLength,
          }) {
            return Text(
              "${currentLength ?? 0}/$maxLength",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            );
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTimePickerField(BuildContext context, String label) {
    TimeOfDay? selectedTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              selectedTime = picked;
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedTime != null
                      ? selectedTime!.format(context)
                      : "-- : --",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                ),
                Icon(Icons.access_time, color: Colors.grey),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Alamat Resto",
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFA80707), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder, color: const Color(0xFFA80707), size: 40),
              SizedBox(height: 5),
              Text(
                "Unggah file Anda di sini",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFFA80707),
                ),
              ),
              SizedBox(height: 5),
              OutlinedButton(
                onPressed: () {},
                child: Text(
                  "Browse files",
                  style: GoogleFonts.poppins(color: const Color(0xFFA80707)),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: const Color(0xFFA80707)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSuccessPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Supaya tidak ada border default
      builder: (BuildContext context) {
        return Container(
          width: double.infinity, // Lebar mengikuti layar penuh
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
                  color: Colors.grey[300], // Warna bar atas biar terlihat
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Image.asset('assets/success.png', height: 150),
              const SizedBox(height: 16),
              Text(
                "Anda berhasil menambah Resto Baru!",
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ), // Ganti NextPage dengan tujuan
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE52020),
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
              Image.asset(
                'assets/cancel.png',
                height: 150,
              ), // Ganti dengan gambar sesuai
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(),
                        ), // Ganti NextPage dengan tujuan
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFE52020)),
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
                          color: Color(0xFFE52020),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.pop(
                          context,
                        ), // Tutup popup, lanjut mengedit
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE52020),
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
