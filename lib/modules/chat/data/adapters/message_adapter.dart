import '../../domain/entities/message_entity.dart';

class MessageAdapter {
  static MessageEntity fromMap(Map<String, dynamic> map) {
    return MessageEntity(
      id: map['id'] as String,
      conversationId: map['conversation_id'] as String,
      sender: map['sender'] as String,
      content: map['content'] as String,
      role: map['role'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  static Map<String, dynamic> toMap(MessageEntity entity) {
    return {
      'id': entity.id.value,
      'conversation_id': entity.conversationId.value,
      'sender': entity.sender.value,
      'content': entity.content.value,
      'role': entity.role?.value,
      'created_at': entity.createdAt.value.toIso8601String(),
    };
  }
}
