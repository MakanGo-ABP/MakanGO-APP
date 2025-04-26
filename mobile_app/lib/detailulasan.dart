import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class DetailUlasanPage extends StatefulWidget {
  final String reviewId;

  const DetailUlasanPage({super.key, required this.reviewId});

  @override
  _DetailUlasanPageState createState() => _DetailUlasanPageState();
}

class _DetailUlasanPageState extends State<DetailUlasanPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Ulasan", style: GoogleFonts.poppins()),
        backgroundColor: Colors.red[700],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('Review').doc(widget.reviewId).get(),
        builder: (context, reviewSnapshot) {
          if (reviewSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (reviewSnapshot.hasError) {
            return Center(child: Text('Error: ${reviewSnapshot.error}'));
          }
          if (!reviewSnapshot.hasData || !reviewSnapshot.data!.exists) {
            return Center(child: Text('Ulasan tidak ditemukan.', style: GoogleFonts.poppins()));
          }

          final reviewData = reviewSnapshot.data!.data() as Map<String, dynamic>;
          final userId = reviewData['userId'] as String;
          final photoUrls = reviewData['photoUrls'] as List<dynamic>? ?? [];
          final videoUrl = reviewData['videoUrl'] as String?;
          final description = reviewData['description'] as String? ?? 'No description';
          final foodRating = reviewData['foodRating'] as int? ?? 0;
          final serviceRating = reviewData['serviceRating'] as int? ?? 0;
          final ambianceRating = reviewData['ambianceRating'] as int? ?? 0;
          final averageRating = reviewData['averageRating'] as double? ?? 0.0;

          // Initialize video player if videoUrl exists
          if (videoUrl != null && _videoController == null) {
            _videoController = VideoPlayerController.network(videoUrl)
              ..initialize().then((_) {
                setState(() {
                  _isVideoInitialized = true;
                });
              }).catchError((error) {
                print('Error initializing video: $error');
              });
          }

          return FutureBuilder<DocumentSnapshot>(
            future: _firestore.collection('User').doc(userId).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasError || !userSnapshot.hasData) {
                return Center(child: Text('Error loading user data'));
              }

              final userData = userSnapshot.data!.data() as Map<String, dynamic>;
              final username = userData['name'] as String? ?? 'Unknown';
              final avatarUrl = userData['avatarUrl'] as String? ?? 'assets/ex_profile.png';

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    photoUrls.isNotEmpty
                        ? Image.network(
                            photoUrls[0],
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/sample_food.png',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/sample_food.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: avatarUrl.startsWith('http')
                                ? NetworkImage(avatarUrl)
                                : AssetImage(avatarUrl) as ImageProvider,
                          ),
                          SizedBox(width: 12),
                          Text(
                            username,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.favorite, color: Colors.red),
                          SizedBox(width: 4),
                          Text(
                            '0 likes', // Replace with actual likes count if implemented
                            style: GoogleFonts.poppins(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rating Rata-rata: ${averageRating.toStringAsFixed(1)}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Makanan: $foodRating/5',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            'Pelayanan: $serviceRating/5',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            'Suasana: $ambianceRating/5',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Deskripsi:',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            description,
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          if (photoUrls.length > 1) ...[
                            SizedBox(height: 16),
                            Text(
                              'Foto Lainnya:',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: photoUrls.length - 1,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Image.network(
                                      photoUrls[index + 1],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.asset(
                                        'assets/sample_food.png',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          if (videoUrl != null) ...[
                            SizedBox(height: 16),
                            Text(
                              'Video:',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _isVideoInitialized && _videoController != null
                                ? Column(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: _videoController!.value.aspectRatio,
                                        child: VideoPlayer(_videoController!),
                                      ),
                                      SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_videoController!.value.isPlaying) {
                                              _videoController!.pause();
                                            } else {
                                              _videoController!.play();
                                            }
                                          });
                                        },
                                        child: Text(
                                          _videoController!.value.isPlaying ? 'Pause' : 'Play',
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(child: CircularProgressIndicator()),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}