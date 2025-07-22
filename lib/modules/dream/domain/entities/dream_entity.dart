import 'package:my_dreams/core/domain/vos/date_time_vo.dart';
import 'package:my_dreams/core/domain/vos/text_vo.dart';

class DreamEntity {
  final TextVO? id;
  final TextVO userId;
  final TextVO message;
  final TextVO answer;
  final TextVO imageUrl;
  final DateTimeVO? createdAt;

  DreamEntity({
    String? id,
    required String userId,
    required String message,
    required String answer,
    required String imageUrl,
    DateTime? createdAt,
  })  : id = id != null ? TextVO(id) : null,
        userId = TextVO(userId),
        message = TextVO(message),
        answer = TextVO(answer),
        imageUrl = TextVO(imageUrl),
        createdAt = createdAt != null ? DateTimeVO(createdAt) : null;
}
