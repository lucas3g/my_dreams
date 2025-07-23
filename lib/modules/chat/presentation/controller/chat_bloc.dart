import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_conversations.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import 'chat_events.dart';
import 'chat_states.dart';

@injectable
class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  final GetConversationsUseCase _getConversations;
  final GetMessagesUseCase _getMessages;
  final SendMessageUseCase _sendMessage;

  ChatBloc({
    required GetConversationsUseCase getConversationsUseCase,
    required GetMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
  })  : _getConversations = getConversationsUseCase,
        _getMessages = getMessagesUseCase,
        _sendMessage = sendMessageUseCase,
        super(ChatInitialState()) {
    on<LoadConversationsEvent>(_onLoadConversations);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onLoadConversations(
    LoadConversationsEvent event,
    Emitter<ChatStates> emit,
  ) async {
    emit(state.loading());
    final result = await _getConversations(event.userId);
    result.get(
      (failure) => emit(state.failure(failure.message)),
      (list) => emit(state.conversations(list)),
    );
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatStates> emit,
  ) async {
    emit(state.loading());
    final result = await _getMessages(
      GetMessagesParams(conversationId: event.conversationId),
    );
    result.get(
      (failure) => emit(state.failure(failure.message)),
      (list) => emit(state.messages(list)),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatStates> emit,
  ) async {
    emit(state.loading());
    final result = await _sendMessage(
      SendMessageParams(
        userId: event.userId,
        conversationId: event.conversationId,
        content: event.content,
      ),
    );

    await result.get(
      (failure) async => emit(state.failure(failure.message)),
      (list) async {
        final convId = list.first.conversationId.value;
        final messagesResult = await _getMessages(
          GetMessagesParams(conversationId: convId),
        );

        messagesResult.get(
          (failure) => emit(state.failure(failure.message)),
          (messages) => emit(state.messages(messages)),
        );
      },
    );
  }
}
