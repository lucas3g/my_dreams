abstract class ChatEvents {}

class LoadConversationsEvent extends ChatEvents {
  final String userId;

  LoadConversationsEvent({required this.userId});
}

class LoadMessagesEvent extends ChatEvents {
  final String conversationId;

  LoadMessagesEvent({required this.conversationId});
}

class SendMessageEvent extends ChatEvents {
  final String content;
  final String userId;
  final String? conversationId;

  SendMessageEvent({
    required this.content,
    required this.userId,
    this.conversationId,
  });
}
