import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserController {
  final FirestoreService _service = FirestoreService();

  Future<UserModel?> fetchUserByEmail(String email) {
    return _service.getUserByEmail(email);
  }
}