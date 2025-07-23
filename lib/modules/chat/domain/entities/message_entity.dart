import 'package:my_dreams/core/domain/vos/date_time_vo.dart';
import 'package:my_dreams/core/domain/vos/text_vo.dart';

class MessageEntity {
  final TextVO id;
  final TextVO conversationId;
  final TextVO sender;
  final TextVO content;
  final TextVO? role;
  final DateTimeVO createdAt;

  MessageEntity({
    required String id,
    required String conversationId,
    required String sender,
    required String content,
    String? role,
    required DateTime createdAt,
  })  : id = TextVO(id),
        conversationId = TextVO(conversationId),
        sender = TextVO(sender),
        content = TextVO(content),
        role = role != null ? TextVO(role) : null,
        createdAt = DateTimeVO(createdAt);
}
