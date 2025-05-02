import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/services/auth.services.dart';
import 'package:mobile_app/detailulasan.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Color(0xFFA80707)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Notifikasi",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: Text(
            "Silakan login untuk melihat notifikasi",
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFFA80707)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Notifikasi",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(user.uid)
            .collection('Notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFA80707)));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/logo_empty.png", width: 150),
                  const SizedBox(height: 10),
                  Text(
                    "Tidak ada notifikasi",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          final notifications = snapshot.data!.docs;

          // Mark all notifications as read when the page is opened
          _markNotificationsAsRead(user.uid, notifications);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index].data() as Map<String, dynamic>;
                final notificationId = notifications[index].id;
                final type = notification['type'] as String;
                final message = notification['message'] as String;
                final createdAt = (notification['createdAt'] as Timestamp?)?.toDate();
                final reviewId = notification['reviewId'] as String?;
                final isRead = notification['isRead'] as bool;

                // Calculate time difference for display (e.g., "2j.")
                String timeDisplay = _formatTime(createdAt);

                return GestureDetector(
                  onTap: () {
                    if (type == 'like' && reviewId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailUlasanPage(reviewId: reviewId),
                        ),
                      );
                    }
                  },
                  child: _buildNotificationItem(
                    icon: type == 'like' ? Icons.favorite : Icons.info,
                    iconColor: type == 'like' ? Colors.red : Colors.green,
                    message: message,
                    time: timeDisplay,
                    isRead: isRead,
                    isXPGain: type == 'like',
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Widget for notification item
  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String message,
    required String time,
    required bool isRead,
    required bool isXPGain,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey.shade100 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: isXPGain && !isRead ? Border.all(color: Colors.red.shade200, width: 1) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.2),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    if (isXPGain && !isRead) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+5 XP',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Format timestamp to display time difference (e.g., "2j.")
  String _formatTime(DateTime? createdAt) {
    if (createdAt == null) return 'Baru saja';
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m.';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}j.';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}h.';
    } else {
      return '${(difference.inDays / 30).floor()}b.';
    }
  }

  // Mark notifications as read
  Future<void> _markNotificationsAsRead(String userId, List<QueryDocumentSnapshot> notifications) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var notification in notifications) {
        final data = notification.data() as Map<String, dynamic>;
        if (data['isRead'] == false) {
          batch.update(
            FirebaseFirestore.instance
                .collection('User')
                .doc(userId)
                .collection('Notifications')
                .doc(notification.id),
            {'isRead': true},
          );
        }
      }
      await batch.commit();
      print('Marked ${notifications.length} notifications as read for user: $userId');
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }
}