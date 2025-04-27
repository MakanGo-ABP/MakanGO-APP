import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String id;
  final String name;
  final String imagePath;
  final String time;
  final String category;
  final double rating;
  final int reviews;
  final String address;
  final double latitude;
  final double longitude;

  Restaurant({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.time,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  // Factory constructor to create a Restaurant from Firestore data
  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return Restaurant(
      id: doc.id,
      name: data?['name']?.toString() ?? '',
      imagePath: data?['imagePath']?.toString() ?? '',
      time: data?['time']?.toString() ?? '',
      category: data?['category']?.toString() ?? '',
      rating: (data?['rating'] is num) ? data!['rating'].toDouble() : 0.0,
      reviews: (data?['reviews'] is num) ? data!['reviews'] as int : 0,
      address: data?['address']?.toString() ?? '',
      latitude: (data?['latitude'] is num) ? data!['latitude'].toDouble() : 0.0,
      longitude:
          (data?['longitude'] is num) ? data!['longitude'].toDouble() : 0.0,
    );
  }

  // Convert Restaurant to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
      'time': time,
      'category': category,
      'rating': rating,
      'reviews': reviews,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
