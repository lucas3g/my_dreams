import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';

import '../../domain/entities/dream_entity.dart';
import '../../domain/usecases/analyze_dream.dart';
import '../../domain/usecases/get_dreams.dart';
import 'dream_events.dart';
import 'dream_states.dart';

@injectable
class DreamBloc extends Bloc<DreamEvents, DreamStates> {
  final AnalyzeDreamUseCase _analyzeDream;
  final GetDreamsUseCase _getDreams;

  DreamBloc({
    required AnalyzeDreamUseCase analyzeDreamUseCase,
    required GetDreamsUseCase getDreamsUseCase,
  }) : _analyzeDream = analyzeDreamUseCase,
       _getDreams = getDreamsUseCase,
       super(DreamInitialState()) {
    on<SendDreamEvent>(_onSendDream);
    on<GetDreamsEvent>(_onGetDreams);
  }

  Future<void> _onSendDream(
    SendDreamEvent event,
    Emitter<DreamStates> emit,
  ) async {
    emit(state.loading());
    DreamEntity? finalDream;

    final stream = _analyzeDream(
      AnalyzeDreamParams(dreamText: event.dreamText, userId: event.userId),
    );

    await emit.forEach<EitherOf<AppFailure, DreamEntity>>(
      stream,
      onData: (result) {
        return result.get((failure) => state.failure(failure.message), (dream) {
          finalDream = dream;
          return state.streaming(dream.answer.value);
        });
      },
    );

    if (finalDream != null) {
      emit(state.analyzed(finalDream!));
    }
  }

  Future<void> _onGetDreams(
    GetDreamsEvent event,
    Emitter<DreamStates> emit,
  ) async {
    emit(state.loading());
    final result = await _getDreams(event.userId);
    result.get(
      (failure) => emit(state.failure(failure.message)),
      (dreams) => emit(state.dreams(dreams)),
    );
  }
}
