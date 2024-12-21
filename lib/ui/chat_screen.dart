import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId;

  const ChatScreen({super.key, required this.recipientId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  static const int _maxMessageLength = 200;

  String? recipientUsername;

  @override
  void initState() {
    super.initState();
    _fetchRecipientData();
  }

  Future<void> _fetchRecipientData() async {
    try {
      final userDoc =
          await _firestore.collection('User').doc(widget.recipientId).get();
      if (userDoc.exists) {
        setState(() {
          recipientUsername = userDoc.data()?['username'] ?? 'Unknown';
        });
      }
    } catch (e) {
      print('Error fetching recipient data: $e');
    }
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty || message.length > _maxMessageLength) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    _messageController.clear();

    final chatId = _getChatId(currentUser.uid, widget.recipientId);

    await _firestore.collection('messages').add({
      'chatId': chatId,
      'senderId': currentUser.uid,
      'recipientId': widget.recipientId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('conversations').doc(chatId).set({
      'participants': [currentUser.uid, widget.recipientId],
      'lastMessage': message,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  String _getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode
        ? '${user1}_$user2'
        : '${user2}_$user1';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return const Center(child: Text("User not logged in."));
    }

    if (widget.recipientId == currentUser.uid) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Invalid Chat"),
          backgroundColor: AppColors.primary,
        ),
        body: const Center(
          child: Text("This is you, just talk aloud"),
        ),
      );
    }

    final chatId = _getChatId(currentUser.uid, widget.recipientId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.accent, // Contrasting color for the circle
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white, // Icon color
              ),
            ),
            const SizedBox(
                width: 14), // Reduced spacing between the icon and text
            Expanded(
              child: Align(
                alignment:
                    Alignment.centerLeft, // Aligns the username to the left
                child: Text(
                  recipientUsername ?? 'Loading...',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('chatId', isEqualTo: chatId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(child: Text('Start a conversation'));
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final messageData = docs[index];
                      final messageText = messageData['message'] ?? 'Unknown';
                      final senderId = messageData['senderId'] ?? 'Unknown';

                      final isMe = senderId == currentUser.uid;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppColors.primary.withOpacity(0.8)
                                : AppColors.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            messageText,
                            style: TextStyle(
                                color: isMe ? Colors.white : AppColors.text),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Start a conversation'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _messageController,
                      maxLength: _maxMessageLength,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        counterText: '', // Hides the character counter
                      ),
                      style: const TextStyle(color: AppColors.text),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
