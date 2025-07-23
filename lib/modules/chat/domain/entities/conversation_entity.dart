import 'package:my_dreams/core/domain/vos/date_time_vo.dart';
import 'package:my_dreams/core/domain/vos/text_vo.dart';

class ConversationEntity {
  final TextVO id;
  final TextVO userId;
  final TextVO title;
  final TextVO summary;
  final DateTimeVO createdAt;
  final DateTimeVO updatedAt;

  ConversationEntity({
    required String id,
    required String userId,
    required String title,
    required String summary,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : id = TextVO(id),
        userId = TextVO(userId),
        title = TextVO(title),
        summary = TextVO(summary),
        createdAt = DateTimeVO(createdAt),
        updatedAt = DateTimeVO(updatedAt);
}
