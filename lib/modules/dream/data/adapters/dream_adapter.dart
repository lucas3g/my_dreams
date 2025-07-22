import '../../domain/entities/dream_entity.dart';

class DreamAdapter {
  static DreamEntity fromMap(Map<String, dynamic> map) {
    return DreamEntity(
      id: map['id'] as String?,
      userId: map['user_id'] as String,
      message: map['description'] as String,
      answer: map['response_ai'] as String,
      imageUrl: map['image_url'] as String? ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  static Map<String, dynamic> toMap(DreamEntity dream) {
    return {
      'user_id': dream.userId.value,
      'description': dream.message.value,
      'response_ai': dream.answer.value,
      'image_url': dream.imageUrl.value,
    };
  }

  static DreamEntity toEntity(Map<String, dynamic> map) {
    return DreamEntity(
      id: map['id'] as String?,
      userId: map['user_id'] as String,
      message: map['description'] as String,
      answer: map['response_ai'] as String,
      imageUrl: map['image_url'] as String? ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }
}
