import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/model/place_list_model.dart';

// Service class for managing PlaceList operations with Firestore
class PlaceListService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'PlaceLists';

  // Create a temporary PlaceList for a user
  Future<PlaceList> createTemporaryPlaceList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }

    final docRef = _firestore.collection(collectionName).doc();
    final placeList = PlaceList(
      id: docRef.id,
      title: '',
      notes: '',
      isPublic: true,
      creatorUid: user.uid,
      restaurantIds: [],
      createdAt: DateTime.now(),
    );

    await docRef.set(placeList.toJson());
    return placeList;
  }

  // Save or update a PlaceList
  Future<void> savePlaceList(PlaceList placeList) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(placeList.id)
          .set(placeList.toJson());
    } catch (e) {
      throw Exception('Failed to save place list: $e');
    }
  }

  // Delete a PlaceList
  Future<void> deletePlaceList(String placeListId) async {
    try {
      await _firestore.collection(collectionName).doc(placeListId).delete();
    } catch (e) {
      throw Exception('Failed to delete place list: $e');
    }
  }

  // Add restaurants to a PlaceList
  Future<void> addRestaurantsToList(
      String placeListId, List<String> restaurantIds) async {
    try {
      await _firestore.collection(collectionName).doc(placeListId).update({
        'restaurantIds': FieldValue.arrayUnion(restaurantIds),
      });
    } catch (e) {
      throw Exception('Failed to add restaurants: $e');
    }
  }

  // Remove a restaurant from a PlaceList
  Future<void> removeRestaurantFromList(
      String placeListId, String restaurantId) async {
    try {
      await _firestore.collection(collectionName).doc(placeListId).update({
        'restaurantIds': FieldValue.arrayRemove([restaurantId]),
      });
    } catch (e) {
      throw Exception('Failed to remove restaurant: $e');
    }
  }

  // Stream of PlaceLists for the current user
  Stream<List<PlaceList>> getPlaceLists() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(collectionName)
        .where('creatorUid', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PlaceList.fromFirestore(doc))
            .toList());
  }
}