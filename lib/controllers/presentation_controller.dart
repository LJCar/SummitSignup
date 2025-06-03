import '../models/presentation_model.dart';
import '../models/user_model.dart';
import '../services/firestore_presentation_service.dart';

class PresentationController {
  final _service = FirestorePresentationService();

  Future<List<PresentationModel>> getEligiblePresentations(UserModel user) async {
    final allPresentations = await _service.fetchPresentations();

    // Filter presentations where nurseType is in the audience list (e.g., "OR")
    return allPresentations.where((p) {
      return p.audience.contains(user.nurseType);
    }).toList();
  }
}