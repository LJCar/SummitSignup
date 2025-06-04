import '../models/presentation_model.dart';
import '../services/firestore_presentation_service.dart';
import '../services/firestore_signup_service.dart';

class SignupController {
  final _signupService = FirestoreSignupService();
  final _presentationService = FirestorePresentationService();

  Future<bool> isPresentationAvailable(String presentationId) async {
    final count = await _signupService.getAttendeeCount(presentationId);
    return count < 10;
  }

  Future<void> registerForSessions({
    required String email,
    required String session1Id,
    required String session2Id,
  }) async {
    await _signupService.addUserToPresentation(session1Id, email);
    await _signupService.addUserToPresentation(session2Id, email);
    await _signupService.markUserAsSignedUp(email);
  }

  Future<List<PresentationModel>> getRegisteredPresentations(String email) async {
    final signedUpIds = await _signupService.getPresentationsForUser(email);
    final allPresentations = await _presentationService.fetchPresentations();

    return allPresentations.where((p) =>
        signedUpIds.any((id) => id.startsWith('${p.id}_'))
    ).toList();
  }

}