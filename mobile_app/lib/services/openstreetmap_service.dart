import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenStreetMapService {
  static const String baseUrl = 'https://nominatim.openstreetmap.org/reverse';

  // Fetch formatted address from coordinates using Nominatim API
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    final url = '$baseUrl?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'MakanGo/1.0 (your.email@example.com)'}, // Nominatim requires a User-Agent
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['address'] != null) {
          return data['display_name'] ?? 'Address not found';
        } else {
          return 'Address not found';
        }
      } else {
        return 'Failed to fetch address';
      }
    } catch (e) {
      print('Error fetching address: $e');
      return 'Error fetching address';
    }
  }
}