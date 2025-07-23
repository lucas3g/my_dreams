import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import 'package:my_dreams/core/domain/entities/usecase.dart';

import '../entities/conversation_entity.dart';
import '../repositories/chat_repository.dart';

@injectable
class GetConversationsUseCase
    implements UseCase<List<ConversationEntity>, String> {
  final ChatRepository _repository;

  GetConversationsUseCase({required ChatRepository repository})
      : _repository = repository;

  @override
  Future<EitherOf<AppFailure, List<ConversationEntity>>> call(
      String userId) {
    return _repository.getConversations(userId);
  }
}
