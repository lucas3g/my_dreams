import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import '../entities/dream_entity.dart';

abstract class DreamRepository {
  Future<EitherOf<AppFailure, DreamEntity>> analyzeDream({
    required String dreamText,
    required String userId,
  });

  Future<EitherOf<AppFailure, String>> generateDreamImage(String dreamText);

  Future<EitherOf<AppFailure, List<DreamEntity>>> getDreams(String userId);
}
