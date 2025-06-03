import '../models/user_model.dart';
import '../services/firestore_user_service.dart';

class UserController {
  final FirestoreUserService _service = FirestoreUserService();

  Future<UserModel?> fetchUserByEmail(String email) {
    return _service.getUserByEmail(email);
  }
}