import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create or Update User
  Future<void> saveUser(User user) async {
    try {
      // Uses the user's unique ID as the document ID
      await _firestore
          .collection('User')
          .doc(user.id)
          .set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }

  // Retrieve User by ID
  Future<User?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('User').doc(userId).get();
      return doc.exists ? User.fromDocument(doc) : null;
    } catch (e) {
      print('Error retrieving user: $e');
      return null;
    }
  }

  // Update Specific User Fields
  Future<void> updateUserFields(
      String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('User').doc(userId).update(updates);
    } catch (e) {
      print('Error updating user fields: $e');
      rethrow;
    }
  }

  // Increment User XP
  Future<void> increaseUserXP(String userId) async {
    try {
      await _firestore
          .collection('User')
          .doc(userId)
          .update({'xp': FieldValue.increment(50)});
    } catch (e) {
      print('Error increasing XP by 50: $e');
      rethrow;
    }
  }

  // Check Username Availability
  Future<bool> isUsernameAvailable(String username) async {
    try {
      // Query to check if username already exists
      QuerySnapshot query = await _firestore
          .collection('User')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      return query.docs.isEmpty;
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }
}
