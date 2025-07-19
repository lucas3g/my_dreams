import '../../domain/entities/dream_entity.dart';

abstract class DreamStates {
  DreamLoadingState loading() => DreamLoadingState();
  DreamFailureState failure(String message) => DreamFailureState(message);
  DreamAnalyzedState analyzed(DreamEntity dream, String imageUrl) =>
      DreamAnalyzedState(dream, imageUrl);
  DreamListLoadedState dreams(List<DreamEntity> list) =>
      DreamListLoadedState(list);
}

class DreamInitialState extends DreamStates {}

class DreamLoadingState extends DreamStates {}

class DreamFailureState extends DreamStates {
  final String message;
  DreamFailureState(this.message);
}

class DreamAnalyzedState extends DreamStates {
  final DreamEntity dream;
  final String imageUrl;

  DreamAnalyzedState(this.dream, this.imageUrl);
}

class DreamListLoadedState extends DreamStates {
  final List<DreamEntity> dreamsList;

  DreamListLoadedState(this.dreamsList);
}

