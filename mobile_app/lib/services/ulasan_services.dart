import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UlasanServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Store a new review with all details
  Future<void> submitReview({
    required String userId,
    required String restaurantId,
    required int foodRating,
    required int serviceRating,
    required int ambianceRating,
    required String description,
    List<File>? photos,
    File? video,
  }) async {
    try {
      // Calculate average rating for the review
      double averageRating =
          (foodRating + serviceRating + ambianceRating) / 3.0;

      // Create review data
      Map<String, dynamic> reviewData = {
        'userId': userId,
        'restaurantId': restaurantId,
        'foodRating': foodRating,
        'serviceRating': serviceRating,
        'ambianceRating': ambianceRating,
        'averageRating': averageRating,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'photoUrls': [],
        'videoUrl': null,
      };

      // Handle photo uploads if provided
      if (photos != null && photos.isNotEmpty) {
        List<String> photoUrls = await _uploadPhotos(
          userId,
          restaurantId,
          photos,
        );
        reviewData['photoUrls'] = photoUrls;
      }

      // Handle video upload if provided
      if (video != null) {
        String videoUrl = await _uploadVideo(userId, restaurantId, video);
        reviewData['videoUrl'] = videoUrl;
      }

      // Store review in Firestore
      await _firestore.collection('Reviews').add(reviewData);

      // Update user's review count
      await checkSumReview(userId: userId);

      // Update restaurant's review count and average rating
      await _updateRestaurantRatingAndReviews(restaurantId, averageRating);
    } catch (e) {
      throw Exception('Error submitting review: $e');
    }
  }

  // Upload photos to Firebase Storage
  Future<List<String>> _uploadPhotos(
    String userId,
    String restaurantId,
    List<File> photos,
  ) async {
    try {
      List<String> photoUrls = [];
      for (int i = 0; i < photos.length; i++) {
        String fileName =
            'reviews/$restaurantId/$userId/photo_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        Reference storageRef = _storage.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(photos[i]);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        photoUrls.add(downloadUrl);
      }
      return photoUrls;
    } catch (e) {
      throw Exception('Error uploading photos: $e');
    }
  }

  // Upload video to Firebase Storage
  Future<String> _uploadVideo(
    String userId,
    String restaurantId,
    File video,
  ) async {
    try {
      String fileName =
          'reviews/$restaurantId/$userId/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      Reference storageRef = _storage.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(video);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading video: $e');
    }
  }

  // Update restaurant's review count and average rating
  Future<void> _updateRestaurantRatingAndReviews(
      String restaurantId, double newReviewRating) async {
    try {
      // Check if restaurant exists
      DocumentSnapshot restaurantDoc =
          await _firestore.collection('Restaurant').doc(restaurantId).get();
      if (!restaurantDoc.exists) {
        throw Exception('Restaurant with ID $restaurantId does not exist');
      }

      // Increment review count
      await _firestore.collection('Restaurant').doc(restaurantId).update({
        'reviews': FieldValue.increment(1),
      });

      // Fetch all reviews for the restaurant
      QuerySnapshot reviews = await _firestore
          .collection('Reviews')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      // Calculate average rating
      double newAverageRating = 0.0;
      int reviewCount = reviews.docs.length;

      if (reviewCount > 0) {
        double totalRating = 0;
        for (var doc in reviews.docs) {
          totalRating += (doc['averageRating'] as double?) ?? 0.0;
        }
        newAverageRating = totalRating / reviewCount;
      }

      // Update restaurant rating
      await _firestore.collection('Restaurant').doc(restaurantId).update({
        'rating': newAverageRating,
      });

      print('Updated Restaurant $restaurantId: Rating = $newAverageRating, Reviews = $reviewCount');
    } catch (e) {
      throw Exception('Error updating restaurant rating and reviews: $e');
    }
  }

  // Update user's review count
  Future<void> checkSumReview({required String userId}) async {
    try {
      await _firestore.collection('User').doc(userId).update({
        'jumlah_review': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Error updating review count: $e');
    }
  }
}