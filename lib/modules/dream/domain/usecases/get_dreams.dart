import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import 'package:my_dreams/core/domain/entities/usecase.dart';
import '../entities/dream_entity.dart';
import '../repositories/dream_repository.dart';

class GetDreamsUseCase implements UseCase<List<DreamEntity>, String> {
  final DreamRepository _repository;

  GetDreamsUseCase({required DreamRepository dreamRepository})
      : _repository = dreamRepository;

  @override
  Future<EitherOf<AppFailure, List<DreamEntity>>> call(String userId) async {
    return _repository.getDreams(userId);
  }
}
