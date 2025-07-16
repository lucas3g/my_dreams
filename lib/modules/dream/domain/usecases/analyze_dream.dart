import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import 'package:my_dreams/core/domain/entities/usecase.dart';

import '../entities/dream_entity.dart';
import '../repositories/dream_repository.dart';

class AnalyzeDreamParams {
  final String dreamText;
  final String userId;

  AnalyzeDreamParams({required this.dreamText, required this.userId});
}

@injectable
class AnalyzeDreamUseCase implements UseCase<DreamEntity, AnalyzeDreamParams> {
  final DreamRepository _repository;

  AnalyzeDreamUseCase({required DreamRepository dreamRepository})
    : _repository = dreamRepository;

  @override
  Future<EitherOf<AppFailure, DreamEntity>> call(
    AnalyzeDreamParams params,
  ) async {
    return _repository.analyzeDream(
      dreamText: params.dreamText,
      userId: params.userId,
    );
  }
}
