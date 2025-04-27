import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceList {
  final String id;
  final String title;
  final String notes;
  final bool isPublic;
  final String creatorUid;
  final List<String> restaurantIds;
  final DateTime createdAt;

  PlaceList({
    required this.id,
    required this.title,
    required this.notes,
    required this.isPublic,
    required this.creatorUid,
    required this.restaurantIds,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'notes': notes,
        'isPublic': isPublic,
        'creatorUid': creatorUid,
        'restaurantIds': restaurantIds,
        'createdAt': createdAt.toIso8601String(), // Keep for backward compatibility
      };

  factory PlaceList.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    dynamic createdAtData = data['createdAt'];
    DateTime createdAt;

    if (createdAtData is Timestamp) {
      createdAt = createdAtData.toDate();
    } else if (createdAtData is String) {
      try {
        createdAt = DateTime.parse(createdAtData);
      } catch (e) {
        print('Error parsing createdAt string: $e, using DateTime.now()');
        createdAt = DateTime.now();
      }
    } else {
      print('Invalid createdAt type: ${createdAtData.runtimeType}, using DateTime.now()');
      createdAt = DateTime.now();
    }

    return PlaceList(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      notes: data['notes'] ?? '',
      isPublic: data['isPublic'] ?? true,
      creatorUid: data['creatorUid'] ?? '',
      restaurantIds: List<String>.from(data['restaurantIds'] ?? []),
      createdAt: createdAt,
    );
  }
}