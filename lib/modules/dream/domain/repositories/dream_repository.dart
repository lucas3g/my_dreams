import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';

import '../entities/dream_entity.dart';

abstract class DreamRepository {
  Future<EitherOf<AppFailure, List<DreamEntity>>> getDreams(String userId);
}
