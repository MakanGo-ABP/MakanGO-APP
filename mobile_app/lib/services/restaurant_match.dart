import 'package:mobile_app/model/restaurant_model.dart';

class RestaurantMatch {
  final Restaurant restaurant;
  final List<String> matchedFields;

  RestaurantMatch({required this.restaurant, required this.matchedFields});
}
