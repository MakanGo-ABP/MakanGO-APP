import 'package:flutter/material.dart';

class DetailUlasanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ambil data dari arguments
    final Map<String, String>? ulasan =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Ulasan"),
        backgroundColor: Colors.redAccent,
      ),
      body:
          ulasan != null
              ? Column(
                children: [
                  Image.asset(ulasan["image"]!),
                  Text(
                    ulasan["username"]!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(ulasan["review"]!),
                ],
              )
              : Center(child: Text("Data tidak ditemukan")),
    );
  }
}
