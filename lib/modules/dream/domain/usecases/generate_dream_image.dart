import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import 'package:my_dreams/core/domain/entities/usecase.dart';
import '../repositories/dream_repository.dart';

@injectable
class GenerateDreamImageUseCase implements UseCase<String, String> {
  final DreamRepository _repository;

  GenerateDreamImageUseCase({required DreamRepository dreamRepository})
      : _repository = dreamRepository;

  @override
  Future<EitherOf<AppFailure, String>> call(String dreamText) {
    return _repository.generateDreamImage(dreamText);
  }
}
