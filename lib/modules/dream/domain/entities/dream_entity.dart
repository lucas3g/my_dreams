import 'package:my_dreams/core/domain/entities/base_entity.dart';
import 'package:my_dreams/core/domain/vos/date_time_vo.dart';
import 'package:my_dreams/core/domain/vos/int_vo.dart';
import 'package:my_dreams/core/domain/vos/text_vo.dart';

class DreamEntity extends BaseEntity {
  TextVO userId;
  TextVO message;
  TextVO answer;
  DateTimeVO createdAt;

  DreamEntity({
    required int id,
    required String userId,
    required String message,
    required String answer,
    required DateTime createdAt,
  })  : userId = TextVO(userId),
        message = TextVO(message),
        answer = TextVO(answer),
        createdAt = DateTimeVO(createdAt),
        super(id: IntVO(id));
}
