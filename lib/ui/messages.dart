import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app/app_theme.dart';
import 'chat_screen.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> _getUsername(String userId) async {
    try {
      final userDoc = await _firestore.collection('User').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data()?['username'] ?? 'Unknown';
      }
      return 'Unknown';
    } catch (e) {
      print('Error fetching username: $e');
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("User not logged in."));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppColors.primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('conversations')
            .where('participants', arrayContains: currentUser.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages found.'));
          }

          final conversations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final participants = conversation['participants'] as List;
              final lastMessage = conversation['lastMessage'] ?? 'No messages yet';
              final recipientId = participants.firstWhere(
                (id) => id != currentUser.uid,
                orElse: () => null,
              );

              if (recipientId == null) {
                return Container();
              }

              return FutureBuilder<String>(
                future: _getUsername(recipientId),
                builder: (context, snapshot) {
                  final username = snapshot.data ?? 'Loading...';

                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.accent, // Contrasting color for the circle
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white, // Icon color for visibility
                      ),
                    ),
                    title: Text(username),
                    subtitle: Text(
                      lastMessage.length > 30
                          ? '${lastMessage.substring(0, 30)}...'
                          : lastMessage,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(recipientId: recipientId),
                        ),
                      );
                    },
                  );

                },
              );
            },
          );
        },
      ),
    );
  }
}