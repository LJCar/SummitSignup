import '../services/firestore_signup_service.dart';

class SignupController {
  final _service = FirestoreSignupService();

  Future<bool> isPresentationAvailable(String presentationId) async {
    final count = await _service.getAttendeeCount(presentationId);
    return count < 10;
  }
}