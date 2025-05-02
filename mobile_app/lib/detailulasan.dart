import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/services/auth.services.dart';
import 'package:mobile_app/services/ulasan_services.dart';

class DetailUlasanPage extends StatefulWidget {
  final String reviewId;

  const DetailUlasanPage({super.key, required this.reviewId});

  @override
  _DetailUlasanPageState createState() => _DetailUlasanPageState();
}

class _DetailUlasanPageState extends State<DetailUlasanPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final UlasanServices _ulasanServices = UlasanServices();
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
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: const Color(0xFFA80707)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Detail Ulasan",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('Review').doc(widget.reviewId).snapshots(),
        builder: (context, reviewSnapshot) {
          if (reviewSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (reviewSnapshot.hasError) {
            return Center(child: Text('Error: ${reviewSnapshot.error}'));
          }
          if (!reviewSnapshot.hasData || !reviewSnapshot.data!.exists) {
            return Center(
              child: Text(
                'Ulasan tidak ditemukan.',
                style: GoogleFonts.poppins(),
              ),
            );
          }

          final reviewData =
              reviewSnapshot.data!.data() as Map<String, dynamic>;
          final userId = reviewData['userId'] as String;
          final restaurantId = reviewData['restaurantId'] as String?;
          final photoUrls = reviewData['photoUrls'] as List<dynamic>? ?? [];
          final videoUrl = reviewData['videoUrl'] as String?;
          final description =
              reviewData['description'] as String? ?? 'No description';
          final foodRating = reviewData['foodRating'] as int? ?? 0;
          final serviceRating = reviewData['serviceRating'] as int? ?? 0;
          final ambianceRating = reviewData['ambianceRating'] as int? ?? 0;
          final timestamp = reviewData['createdAt'] as Timestamp?;
          final likes = reviewData['likes'] as int? ?? 0;

          // Format tanggal
          String formattedDate = 'Unknown date';
          if (timestamp != null) {
            final date = timestamp.toDate();
            formattedDate = DateFormat('dd MMM yyyy').format(date);
          }

          // Initialize video player if videoUrl exists
          if (videoUrl != null && _videoController == null) {
            _videoController = VideoPlayerController.network(videoUrl)
              ..initialize()
                  .then((_) {
                    setState(() {
                      _isVideoInitialized = true;
                    });
                  })
                  .catchError((error) {
                    print('Error initializing video: $error');
                  });
          }

          return FutureBuilder<DocumentSnapshot>(
            future: _firestore.collection('User').doc(userId).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasError) {
                return Center(
                  child: Text('Error loading user data: ${userSnapshot.error}'),
                );
              }
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Center(child: Text('Pengguna tidak ditemukan.'));
              }

              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>;
              final username = userData['name'] as String? ?? 'Unknown';
              final avatarUrl =
                  userData['avatarUrl'] as String? ?? 'assets/ex_profile.png';
              final userLevel = userData['level'] as int? ?? 1;
              final userReviews = userData['jumlah_review'] as int? ?? 0;
              final userSavedPlaces = userData['savedPlacesCount'] as int? ?? 0;

              return FutureBuilder<DocumentSnapshot>(
                future:
                    restaurantId != null
                        ? _firestore
                            .collection('Restaurant')
                            .doc(restaurantId)
                            .get()
                        : Future.value(null),
                builder: (context, restaurantSnapshot) {
                  if (restaurantSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (restaurantSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading restaurant data: ${restaurantSnapshot.error}',
                      ),
                    );
                  }

                  String restaurantName = 'Unknown Restaurant';
                  String restaurantAddress = 'Unknown Address';
                  double restaurantRating = 0.0;
                  int restaurantReviews = 0;

                  if (restaurantSnapshot.hasData &&
                      restaurantSnapshot.data != null &&
                      restaurantSnapshot.data!.exists) {
                    final restaurantData =
                        restaurantSnapshot.data!.data() as Map<String, dynamic>;
                    restaurantName =
                        restaurantData['name'] as String? ??
                        'Unknown Restaurant';
                    restaurantAddress =
                        restaurantData['address'] as String? ??
                        'Unknown Address';
                    restaurantRating =
                        restaurantData['rating'] as double? ?? 0.0;
                    restaurantReviews = restaurantData['reviews'] as int? ?? 0;
                  }

                  return Stack(
                    children: [
                      // Gambar utama di bagian atas
                      SizedBox(
                        width: double.infinity,
                        height: 400,
                        child:
                            photoUrls.isNotEmpty
                                ? Image.network(
                                  photoUrls[0],
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
                                            'assets/sample_food.png',
                                            fit: BoxFit.cover,
                                          ),
                                )
                                : Image.asset(
                                  'assets/sample_food.png',
                                  fit: BoxFit.cover,
                                ),
                      ),
                      // Konten dalam DraggableScrollableSheet
                      DraggableScrollableSheet(
                        initialChildSize: 0.67,
                        maxChildSize: 0.96,
                        minChildSize: 0.6,
                        builder: (context, scrollController) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Garis geser
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 25,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 5,
                                          width: 35,
                                          color: Colors.black12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Info Pengguna
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            avatarUrl.startsWith('http')
                                                ? NetworkImage(avatarUrl)
                                                : AssetImage(avatarUrl)
                                                    as ImageProvider,
                                      ),
                                      SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                username,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '$userReviews Ulasan • $userSavedPlaces Daftar Tempat',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'Level $userLevel',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      FutureBuilder<bool>(
                                        future: _ulasanServices.hasUserLikedReview(
                                          reviewId: widget.reviewId,
                                          userId: _authService.currentUser?.uid ?? '',
                                        ),
                                        builder: (context, likeSnapshot) {
                                          if (likeSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          }
                                          if (likeSnapshot.hasError) {
                                            return Text('Error');
                                          }

                                          final isLiked = likeSnapshot.data ?? false;

                                          return Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  isLiked
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Color(0xFFA80707),
                                                  size: 20,
                                                ),
                                                onPressed: () async {
                                                  final user = _authService.currentUser;
                                                  if (user == null) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Silakan login untuk menyukai ulasan'),
                                                      ),
                                                    );
                                                    return;
                                                  }
                                                  try {
                                                    await _ulasanServices
                                                        .toggleLikeReview(
                                                      reviewId: widget.reviewId,
                                                      userId: user.uid,
                                                    );
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Error: ${e.toString()}'),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                '$likes',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  // Rating (Satu baris dengan background linear pada bintang dan angka)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Makanan',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFE52020),
                                              Color(0xFFA80707),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow[700],
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '$foodRating',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '•',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Pelayanan',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFE52020),
                                              Color(0xFFA80707),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow[700],
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '$serviceRating',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '•',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Suasana',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFE52020),
                                              Color(0xFFA80707),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow[700],
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '$ambianceRating',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 16),
                                  // Deskripsi
                                  Text(
                                    description,
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  SizedBox(height: 8),
                                  // Tanggal
                                  Text(
                                    formattedDate,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  // Foto Lainnya
                                  if (photoUrls.length > 1) ...[
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
                                            padding: const EdgeInsets.only(
                                              right: 8.0,
                                            ),
                                            child: Image.network(
                                              photoUrls[index + 1],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Image.asset(
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
                                    SizedBox(height: 16),
                                  ],
                                  // Video
                                  if (videoUrl != null) ...[
                                    Text(
                                      'Video',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFA80707),
                                      ),
                                    ),
                                    _isVideoInitialized &&
                                            _videoController != null
                                        ? Column(
                                          children: [
                                            AspectRatio(
                                              aspectRatio:
                                                  _videoController!
                                                      .value
                                                      .aspectRatio,
                                              child: VideoPlayer(
                                                _videoController!,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (_videoController!
                                                      .value
                                                      .isPlaying) {
                                                    _videoController!.pause();
                                                  } else {
                                                    _videoController!.play();
                                                  }
                                                });
                                              },
                                              child: Text(
                                                _videoController!
                                                        .value
                                                        .isPlaying
                                                    ? 'Pause'
                                                    : 'Play',
                                                style: GoogleFonts.poppins(),
                                              ),
                                            ),
                                          ],
                                        )
                                        : Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    SizedBox(height: 16),
                                  ],
                                  // Info Restoran
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                      vertical: 10.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Colors
                                                  .grey
                                                  .shade300, // Border color
                                          width: 1.0, // Border width
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ), // Rounded corners
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                          10.0,
                                        ), // Gap between border and content
                                        child: Row(
                                          children: [
                                            // Ikon Lokasi
                                            Icon(
                                              Icons.location_pin,
                                              color: Color(0xFFA80707),
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            // Nama Restoran dan Alamat
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    restaurantName
                                                        .toUpperCase(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    restaurantAddress,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Rating Box dan Jumlah Ulasan
                                            Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                          colors: [
                                                            Color(0xFFE52020),
                                                            Color(0xFFA80707),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end:
                                                              Alignment
                                                                  .bottomRight,
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            12,
                                                          ),
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        offset: Offset(0, 4),
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                            Colors.yellow[700],
                                                        size: 16,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        restaurantRating
                                                            .toStringAsFixed(1),
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  '$restaurantReviews',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}