import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSignupService {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'presentation_signup';

  Future<int> getAttendeeCount(String presentationId) async {
    final doc = await _firestore.collection(_collection).doc(presentationId).get();
    if (doc.exists && doc.data()?['attendees'] is List) {
      return (doc.data()?['attendees'] as List).length;
    }
    return 0;
  }

  Future<void> addUserToPresentation(String presentationId, String email) async {
    final docRef = _firestore.collection(_collection).doc(presentationId);

    await docRef.set({
      'attendees': FieldValue.arrayUnion([email]),
    }, SetOptions(merge: true));
  }

  Future<void> markUserAsSignedUp(String email) async {
    final userRef = _firestore.collection('attendees').doc(email);
    await userRef.set({'signedUp': true}, SetOptions(merge: true));
  }

  Future<List<String>> getPresentationsForUser(String email) async {
    final snapshot = await _firestore.collection(_collection).get();
    final List<String> result = [];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final attendees = List<String>.from(data['attendees'] ?? []);
      if (attendees.contains(email)) {
        result.add(doc.id);
      }
    }

    return result;
  }
}