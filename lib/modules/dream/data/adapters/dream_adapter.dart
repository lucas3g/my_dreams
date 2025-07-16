import '../../domain/entities/dream_entity.dart';

class DreamAdapter {
  static DreamEntity fromMap(Map<String, dynamic> map) {
    return DreamEntity(
      id: map['id'] ?? 0,
      userId: map['user_id'] as String,
      message: map['description'] as String,
      answer: map['response_ai'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  static Map<String, dynamic> toMap(DreamEntity dream) {
    return {
      'user_id': dream.userId.value,
      'description': dream.message.value,
      'response_ai': dream.answer.value,
    };
  }
}
