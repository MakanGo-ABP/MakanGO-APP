import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:mobile_app/services/profile_service.dart';

class UlasanServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ProfileService _profileService = ProfileService();

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
        'likes': 0, // Initialize likes count
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
      await _firestore.collection('Review').add(reviewData);

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
          .collection('Review')
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
      print('Incremented jumlah_review for user $userId');
    } catch (e) {
      throw Exception('Error updating review count: $e');
    }
  }

  // Create a notification for a like with XP info
  Future<void> _createLikeNotification({
    required String reviewId,
    required String likerUserId,
    required String reviewOwnerId,
  }) async {
    try {
      // Fetch liker's name
      DocumentSnapshot likerDoc =
          await _firestore.collection('User').doc(likerUserId).get();
      String likerName = likerDoc.exists ? likerDoc['name'] ?? 'Someone' : 'Someone';

      // Create notification data
      Map<String, dynamic> notificationData = {
        'type': 'like',
        'message': '$likerName menyukai ulasanmu! +5 XP',
        'reviewId': reviewId,
        'likerUserId': likerUserId,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      };

      // Store notification in the review owner's Notifications subcollection
      await _firestore
          .collection('User')
          .doc(reviewOwnerId)
          .collection('Notifications')
          .add(notificationData);
      print('Created like notification for user $reviewOwnerId: $likerName menyukai ulasanmu! +5 XP');
    } catch (e) {
      print('Error creating like notification: $e');
      throw Exception('Error creating like notification: $e');
    }
  }

  // Toggle like for a review and award 5 XP to review owner
  Future<void> toggleLikeReview({
    required String reviewId,
    required String userId,
  }) async {
    try {
      DocumentReference reviewRef = _firestore.collection('Review').doc(reviewId);
      DocumentReference likeRef = reviewRef.collection('likes').doc(userId);

      // Fetch review to get the owner's userId
      DocumentSnapshot reviewDoc = await reviewRef.get();
      if (!reviewDoc.exists) {
        throw Exception('Review does not exist');
      }
      String reviewOwnerId = reviewDoc['userId'];

      // Check if the user has already liked the review
      DocumentSnapshot likeDoc = await likeRef.get();
      bool isLiked = likeDoc.exists;

      // Run in a transaction to ensure atomic updates
      await _firestore.runTransaction((transaction) async {
        if (isLiked) {
          // Unlike: Remove like document and decrement likes count
          transaction.delete(likeRef);
          transaction.update(reviewRef, {
            'likes': FieldValue.increment(-1),
          });
        } else {
          // Like: Add like document and increment likes count
          transaction.set(likeRef, {
            'likedAt': FieldValue.serverTimestamp(),
          });
          transaction.update(reviewRef, {
            'likes': FieldValue.increment(1),
          });
        }
      });

      // Create notification and award XP only if the user liked the review (not unliked)
      if (!isLiked && userId != reviewOwnerId) {
        await _createLikeNotification(
          reviewId: reviewId,
          likerUserId: userId,
          reviewOwnerId: reviewOwnerId,
        );
        // Award 5 XP to the review owner
        print('Awarding 5 XP to review owner: $reviewOwnerId for review: $reviewId');
        await _profileService.updateUserXP(userId: reviewOwnerId, xpToAdd: 5);
      }
    } catch (e) {
      print('Error toggling like: $e');
      throw Exception('Error toggling like: $e');
    }
  }

  // Check if a user has liked a review
  Future<bool> hasUserLikedReview({
    required String reviewId,
    required String userId,
  }) async {
    try {
      DocumentSnapshot likeDoc = await _firestore
          .collection('Review')
          .doc(reviewId)
          .collection('likes')
          .doc(userId)
          .get();
      return likeDoc.exists;
    } catch (e) {
      throw Exception('Error checking like status: $e');
    }
  }

  // Delete a review
  Future<void> deleteReview({
    required String reviewId,
    required String userId,
    required String restaurantId,
    List<String>? photoUrls,
    String? videoUrl,
  }) async {
    try {
      // Run in a transaction to ensure atomic updates
      await _firestore.runTransaction((transaction) async {
        // Delete the review document
        DocumentReference reviewRef = _firestore.collection('Review').doc(reviewId);
        transaction.delete(reviewRef);

        // Delete associated likes subcollection
        QuerySnapshot likesSnapshot = await _firestore
            .collection('Review')
            .doc(reviewId)
            .collection('likes')
            .get();
        for (var likeDoc in likesSnapshot.docs) {
          transaction.delete(likeDoc.reference);
        }

        // Update user's review count
        DocumentReference userRef = _firestore.collection('User').doc(userId);
        transaction.update(userRef, {
          'jumlah_review': FieldValue.increment(-1),
        });
      });

      // Delete associated media from Firebase Storage
      if (photoUrls != null && photoUrls.isNotEmpty) {
        for (String photoUrl in photoUrls) {
          try {
            await _storage.refFromURL(photoUrl).delete();
          } catch (e) {
            print('Error deleting photo $photoUrl: $e');
          }
        }
      }
      if (videoUrl != null) {
        try {
          await _storage.refFromURL(videoUrl).delete();
        } catch (e) {
          print('Error deleting video $videoUrl: $e');
        }
      }

      // Update restaurant's review count and average rating
      await _updateRestaurantAfterDeletion(restaurantId);
    } catch (e) {
      throw Exception('Error deleting review: $e');
    }
  }

  // Update restaurant's review count and rating after deletion
  Future<void> _updateRestaurantAfterDeletion(String restaurantId) async {
    try {
      // Check if restaurant exists
      DocumentSnapshot restaurantDoc =
          await _firestore.collection('Restaurant').doc(restaurantId).get();
      if (!restaurantDoc.exists) {
        throw Exception('Restaurant with ID $restaurantId does not exist');
      }

      // Decrement review count
      await _firestore.collection('Restaurant').doc(restaurantId).update({
        'reviews': FieldValue.increment(-1),
      });

      // Fetch remaining reviews for the restaurant
      QuerySnapshot reviews = await _firestore
          .collection('Review')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      // Calculate new average rating
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
      throw Exception('Error updating restaurant after deletion: $e');
    }
  }
}