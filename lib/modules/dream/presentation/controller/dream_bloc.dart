import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_dreams.dart';
import 'dream_events.dart';
import 'dream_states.dart';

@injectable
class DreamBloc extends Bloc<DreamEvents, DreamStates> {
  final GetDreamsUseCase _getDreams;

  DreamBloc({required GetDreamsUseCase getDreamsUseCase})
    : _getDreams = getDreamsUseCase,
      super(DreamInitialState()) {
    on<GetDreamsEvent>(_onGetDreams);
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
