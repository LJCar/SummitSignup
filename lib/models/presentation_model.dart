class PresentationModel {
  final String id;
  final List<String> audience;
  final String room;
  final List<int> session;
  final String speaker;
  final String title;

  PresentationModel({
    required this.id,
    required this.audience,
    required this.room,
    required this.session,
    required this.speaker,
    required this.title,
  });

  factory PresentationModel.fromMap(Map<String, dynamic> data, String docId) {
    return PresentationModel(
      id: docId,
      audience: List<String>.from(data['audience'] ?? []),
      room: data['room'] ?? '',
      session: List<int>.from(data['session'] ?? []),
      speaker: data['speaker'] ?? '',
      title: data['title'] ?? '',
    );
  }
}