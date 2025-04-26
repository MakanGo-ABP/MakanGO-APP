import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/model/restaurant_model.dart';

class RestaurantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to get all restaurants from Firestore
  Stream<List<Restaurant>> getRestaurants() {
    return _firestore.collection('Restaurant').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Restaurant.fromFirestore(doc)).toList());
  }
}