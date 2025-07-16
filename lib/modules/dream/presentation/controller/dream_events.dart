abstract class DreamEvents {}

class SendDreamEvent extends DreamEvents {
  final String dreamText;
  final String userId;

  SendDreamEvent({required this.dreamText, required this.userId});
}

class GetDreamsEvent extends DreamEvents {
  final String userId;

  GetDreamsEvent({required this.userId});
}
