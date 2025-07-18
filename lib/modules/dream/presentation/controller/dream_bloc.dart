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

    final result = await _analyzeDream(
      AnalyzeDreamParams(dreamText: event.dreamText, userId: event.userId),
    );

    result.get(
      (failure) => emit(state.failure(failure.message)),
      (dream) async {
        var buffer = '';
        final words = dream.answer.value.split(' ');
        for (final word in words) {
          buffer += buffer.isEmpty ? word : ' $word';
          emit(state.streaming(buffer));
          await Future.delayed(const Duration(milliseconds: 50));
        }
        emit(state.analyzed(dream));
      },
    );
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
