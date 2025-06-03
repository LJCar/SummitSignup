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
}