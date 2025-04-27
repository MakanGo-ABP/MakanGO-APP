import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/model/restaurant_model.dart';
import 'package:mobile_app/services/restaurant_match.dart';

class RestaurantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Preprocess text: convert to lowercase and remove commas/periods
  String _preprocessText(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[,.]'), '');
  }

  // Stream to get all restaurants from Firestore with preprocessed fields
  Stream<List<Restaurant>> getRestaurants() {
    return _firestore.collection('Restaurant').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          final restaurant = Restaurant.fromFirestore(doc);
          return Restaurant(
            id: restaurant.id,
            name: _preprocessText(restaurant.name),
            imagePath: restaurant.imagePath,
            time: restaurant.time,
            category: _preprocessText(restaurant.category),
            rating: restaurant.rating,
            reviews: restaurant.reviews,
            address: _preprocessText(restaurant.address),
            latitude: restaurant.latitude,
            longitude: restaurant.longitude,
          );
        }).toList());
  }

  // Search restaurants by keyword in name, category, or address
  Stream<List<RestaurantMatch>> searchRestaurants(String keyword) {
    print('Searching for keyword: "$keyword"');
    if (keyword.isEmpty) {
      print('Keyword is empty, returning empty list');
      return Stream.value([]);
    }

    // Preprocess keyword: lowercase and remove commas/periods
    String processedKeyword = _preprocessText(keyword);
    // Split keyword into individual words
    List<String> searchWords = processedKeyword.split(RegExp(r'\s+'));

    return Stream.fromFuture(_performSearch(searchWords));
  }

  Future<List<RestaurantMatch>> _performSearch(List<String> searchWords) async {
    print('Search words: $searchWords');
    Set<RestaurantMatch> allMatches = {};

    // Fetch all restaurants once
    QuerySnapshot snapshot = await _firestore.collection('Restaurant').get();

    // Process each restaurant
    for (var doc in snapshot.docs) {
      Restaurant restaurant = Restaurant.fromFirestore(doc);
      // Preprocess fields
      String name = _preprocessText(restaurant.name);
      String category = _preprocessText(restaurant.category);
      String address = _preprocessText(restaurant.address);
      List<String> matchedFields = [];

      // Check each search word
      for (String word in searchWords) {
        if (word.isEmpty) {
          print('Skipping empty word');
          continue;
        }

        // Check if word matches any field
        if (name.contains(word)) {
          matchedFields.add('name');
        }
        if (category.contains(word)) {
          matchedFields.add('category');
        }
        if (address.contains(word)) {
          matchedFields.add('address');
        }
      }

      // If there are matches, add to results
      if (matchedFields.isNotEmpty) {
        allMatches.add(RestaurantMatch(
          restaurant: restaurant, // Use original restaurant, not preprocessed
          matchedFields: matchedFields,
        ));
      }
    }

    print('Total unique matches: ${allMatches.length}');
    return allMatches.toList();
  }
}