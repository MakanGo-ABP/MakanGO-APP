import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/model/restaurant_model.dart';
import 'package:mobile_app/services/restaurant_match.dart';

class RestaurantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to get all restaurants from Firestore
  Stream<List<Restaurant>> getRestaurants() {
    return _firestore
        .collection('Restaurant')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Restaurant.fromFirestore(doc))
                  .toList(),
        );
  }

  // Search restaurants by keyword in name, category, or address
  Stream<List<RestaurantMatch>> searchRestaurants(String keyword) {
    print('Searching for keyword: "$keyword"');
    if (keyword.isEmpty) {
      print('Keyword is empty, returning empty list');
      return Stream.value([]);
    }

    // Split keyword into individual words
    List<String> searchWords = keyword.toLowerCase().split(RegExp(r'\s+'));

    return Stream.fromFuture(_performSearch(searchWords));
  }

  Future<List<RestaurantMatch>> _performSearch(List<String> searchWords) async {
    print('Search words: $searchWords');
    Set<RestaurantMatch> allMatches = {};

    // Process each word
    for (String word in searchWords) {
      if (word.isEmpty) {
        print('Skipping empty word');
        continue;
      }

      String searchKey = word;
      String endKey = '$searchKey\uf8ff';

      print('Querying for word: "$searchKey"');

      // Query for name_lower
      QuerySnapshot nameSnapshot =
          await _firestore
              .collection('Restaurant')
              .where('name_lower', isGreaterThanOrEqualTo: searchKey)
              .where('name_lower', isLessThanOrEqualTo: endKey)
              .get();
      print('Name query returned ${nameSnapshot.docs.length} results');

      // Query for category_lower
      QuerySnapshot categorySnapshot =
          await _firestore
              .collection('Restaurant')
              .where('category_lower', isGreaterThanOrEqualTo: searchKey)
              .where('category_lower', isLessThanOrEqualTo: endKey)
              .get();
      print('Category query returned ${categorySnapshot.docs.length} results');

      // Query for address_lower
      QuerySnapshot addressSnapshot =
          await _firestore
              .collection('Restaurant')
              .where('address_lower', isGreaterThanOrEqualTo: searchKey)
              .where('address_lower', isLessThanOrEqualTo: endKey)
              .get();
      print('Address query returned ${addressSnapshot.docs.length} results');

      // Process name matches
      for (var doc in nameSnapshot.docs) {
        Restaurant restaurant = Restaurant.fromFirestore(doc);
        allMatches.add(
          RestaurantMatch(restaurant: restaurant, matchedFields: ['name']),
        );
      }

      // Process category matches
      for (var doc in categorySnapshot.docs) {
        Restaurant restaurant = Restaurant.fromFirestore(doc);
        allMatches.add(
          RestaurantMatch(restaurant: restaurant, matchedFields: ['category']),
        );
      }

      // Process address matches
      for (var doc in addressSnapshot.docs) {
        Restaurant restaurant = Restaurant.fromFirestore(doc);
        allMatches.add(
          RestaurantMatch(restaurant: restaurant, matchedFields: ['address']),
        );
      }
    }

    // Combine matched fields for restaurants that appear in multiple queries
    Map<String, RestaurantMatch> consolidatedMatches = {};
    for (var match in allMatches) {
      String restaurantId = match.restaurant.id;
      if (consolidatedMatches.containsKey(restaurantId)) {
        consolidatedMatches[restaurantId]!.matchedFields.addAll(
          match.matchedFields,
        );
      } else {
        consolidatedMatches[restaurantId] = RestaurantMatch(
          restaurant: match.restaurant,
          matchedFields: List.from(match.matchedFields),
        );
      }
    }

    print('Total unique matches: ${consolidatedMatches.length}');
    return consolidatedMatches.values.toList();
  }
}
