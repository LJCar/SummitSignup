import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/presentation_model.dart';

class FirestorePresentationService {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'presentations';

  Future<List<PresentationModel>> fetchPresentations() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) {
        return PresentationModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
