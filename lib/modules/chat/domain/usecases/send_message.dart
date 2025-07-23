import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import 'package:my_dreams/core/domain/entities/usecase.dart';

import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageParams {
  final String userId;
  final String? conversationId;
  final String content;

  SendMessageParams({
    required this.userId,
    required this.content,
    this.conversationId,
  });
}

@injectable
class SendMessageUseCase
    implements UseCase<List<MessageEntity>, SendMessageParams> {
  final ChatRepository _repository;

  SendMessageUseCase({required ChatRepository repository})
      : _repository = repository;

  @override
  Future<EitherOf<AppFailure, List<MessageEntity>>> call(
      SendMessageParams params) {
    return _repository.sendMessage(
      userId: params.userId,
      conversationId: params.conversationId,
      content: params.content,
    );
  }
}
