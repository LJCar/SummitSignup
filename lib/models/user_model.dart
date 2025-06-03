class UserModel {
  final String name;
  final String email;
  final String nurseType;
  final bool signedUp;

  UserModel({
    required this.name,
    required this.email,
    required this.nurseType,
    required this.signedUp
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String docId) {
    return UserModel(
      name: data['name'],
      email: docId,
      nurseType: data['nurseType'],
      signedUp: data['signedUp'] ?? false
    );
  }
}