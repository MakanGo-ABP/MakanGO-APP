import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/model/restaurant_model.dart';
import 'package:mobile_app/search_page.dart';
import 'package:mobile_app/services/place_list_service.dart';
import 'package:mobile_app/services/restaurant_services.dart';
import 'package:mobile_app/services/restaurant_match.dart';

class TambahtempatPage extends StatefulWidget {
  final String placeListId;

  const TambahtempatPage({
    super.key,
    required this.placeListId,
  });

  @override
  _TambahtempatPageState createState() => _TambahtempatPageState();
}

class _TambahtempatPageState extends State<TambahtempatPage> {
  final RestaurantService _restaurantService = RestaurantService();
  final PlaceListService _placeListService = PlaceListService();
  final List<String> _selectedRestaurantIds = [];

  void _toggleRestaurantSelection(String restaurantId) {
    if (restaurantId.isEmpty) {
      print('Warning: Attempted to select empty restaurant ID');
      return;
    }
    print('Toggling selection for restaurant ID: $restaurantId');
    setState(() {
      if (_selectedRestaurantIds.contains(restaurantId)) {
        _selectedRestaurantIds.remove(restaurantId);
        print('Removed $restaurantId from selection');
      } else {
        _selectedRestaurantIds.add(restaurantId);
        print('Added $restaurantId to selection');
      }
      print('Current selected IDs: $_selectedRestaurantIds');
    });
  }

  void _saveSelections() async {
    // Fallback: Use hardcoded IDs if none selected (for testing)
    final idsToSave = _selectedRestaurantIds.isNotEmpty
        ? _selectedRestaurantIds
        : ['your_resto_id_1', 'your_resto_id_2', 'your_resto_id_3']; // REPLACE with actual Restaurant IDs
    print('Preparing to save ${idsToSave.length} restaurant IDs: $idsToSave for place list: ${widget.placeListId}');

    if (idsToSave.isEmpty) {
      print('No restaurant IDs to save');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih setidaknya satu restoran')),
      );
      return;
    }

    try {
      await _placeListService.addRestaurantsToList(widget.placeListId, idsToSave);
      print('Save successful for ${idsToSave.length} restaurants');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${idsToSave.length} restoran berhasil ditambahkan')),
      );
      Navigator.pop(context, true); // Indicate success
    } catch (e) {
      print('Error saving restaurant IDs: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan restoran: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building TambahtempatPage for placeListId: ${widget.placeListId}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFFA80707)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Tambah Tempat (${_selectedRestaurantIds.length} dipilih)",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () {
                print('Selesai button pressed');
                _saveSelections();
              },
              child: Text(
                "Selesai",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA80707),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                print('Navigating to SearchPage');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                ).then((value) {
                  if (value is Restaurant) {
                    print('Received restaurant from SearchPage: ${value.id} (name: ${value.name})');
                    _toggleRestaurantSelection(value.id);
                  } else if (value is RestaurantMatch) {
                    print('Received RestaurantMatch from SearchPage: ${value.restaurant.id} (name: ${value.restaurant.name})');
                    _toggleRestaurantSelection(value.restaurant.id);
                  } else {
                    print('Invalid value from SearchPage: $value');
                  }
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      "Cari restoran...",
                      style:
                          GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Restaurant>>(
              stream: _restaurantService.getRestaurants(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('Waiting for restaurant stream');
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print('Error in restaurant stream: ${snapshot.error}');
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.red),
                    ),
                  );
                }
                final restaurants = snapshot.data ?? [];
                if (restaurants.isEmpty) {
                  print('No restaurants found in stream');
                  return Center(
                    child: Text(
                      'Tidak ada restoran ditemukan',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  );
                }
                print('Loaded ${restaurants.length} restaurants: ${restaurants.map((r) => "${r.name} (ID: ${r.id})").toList()}');
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    final isSelected =
                        _selectedRestaurantIds.contains(restaurant.id);
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: restaurant.imagePath.startsWith('http')
                            ? Image.network(
                                restaurant.imagePath,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.image_not_supported),
                              )
                            : Image.asset(
                                restaurant.imagePath,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.image_not_supported),
                              ),
                        title: Text(
                          restaurant.name,
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          restaurant.address,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey),
                        ),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            print('Checkbox changed for ${restaurant.name} (ID: ${restaurant.id})');
                            _toggleRestaurantSelection(restaurant.id);
                          },
                          activeColor: Color(0xFFA80707),
                        ),
                        onTap: () {
                          print('ListTile tapped for ${restaurant.name} (ID: ${restaurant.id})');
                          _toggleRestaurantSelection(restaurant.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}