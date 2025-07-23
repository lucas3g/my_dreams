import '../../domain/entities/conversation_entity.dart';

class ConversationAdapter {
  static ConversationEntity fromMap(Map<String, dynamic> map) {
    return ConversationEntity(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  static Map<String, dynamic> toMap(ConversationEntity entity) {
    return {
      'id': entity.id.value,
      'user_id': entity.userId.value,
      'title': entity.title.value,
      'summary': entity.summary.value,
      'created_at': entity.createdAt.value.toIso8601String(),
      'updated_at': entity.updatedAt.value.toIso8601String(),
    };
  }
}
