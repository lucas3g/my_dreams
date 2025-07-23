import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import 'package:my_dreams/core/domain/entities/usecase.dart';

import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessagesParams {
  final String conversationId;
  final int limit;
  final int offset;

  GetMessagesParams({
    required this.conversationId,
    this.limit = 20,
    this.offset = 0,
  });
}

@injectable
class GetMessagesUseCase
    implements UseCase<List<MessageEntity>, GetMessagesParams> {
  final ChatRepository _repository;

  GetMessagesUseCase({required ChatRepository repository})
      : _repository = repository;

  @override
  Future<EitherOf<AppFailure, List<MessageEntity>>> call(
      GetMessagesParams params) {
    return _repository.getMessages(
      conversationId: params.conversationId,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
