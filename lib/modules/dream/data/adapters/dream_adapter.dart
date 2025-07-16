import '../../domain/entities/dream_entity.dart';

class DreamAdapter {
  static DreamEntity fromMap(Map<String, dynamic> map) {
    return DreamEntity(
      id: map['id'] ?? 0,
      userId: map['user_id'] as String,
      message: map['message'] as String,
      answer: map['answer'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  static Map<String, dynamic> toMap(DreamEntity dream) {
    return {
      'user_id': dream.userId.value,
      'message': dream.message.value,
      'answer': dream.answer.value,
      'created_at': dream.createdAt.value.toIso8601String(),
    };
  }
}
