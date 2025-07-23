import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatStates {
  ChatLoadingState loading() => ChatLoadingState();
  ChatFailureState failure(String message) => ChatFailureState(message);
  ChatLoadedMessagesState messages(List<MessageEntity> list) =>
      ChatLoadedMessagesState(list);
  ChatLoadedConversationsState conversations(List<ConversationEntity> list) =>
      ChatLoadedConversationsState(list);
}

class ChatInitialState extends ChatStates {}

class ChatLoadingState extends ChatStates {}

class ChatFailureState extends ChatStates {
  final String message;
  ChatFailureState(this.message);
}

class ChatLoadedMessagesState extends ChatStates {
  final List<MessageEntity> messagesList;
  ChatLoadedMessagesState(this.messagesList);
}

class ChatLoadedConversationsState extends ChatStates {
  final List<ConversationEntity> conversationsList;
  ChatLoadedConversationsState(this.conversationsList);
}
