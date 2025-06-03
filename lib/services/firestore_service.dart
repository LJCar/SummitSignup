import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<UserModel?> getUserByEmail(String email) async {
    final doc = await _db.collection('attendees').doc(email).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    return UserModel(
      name: data['name'],
      email: doc.id,
      nurseType: data['nurseType'],
      signedUp: data['signedUp']
    );
  }
}
