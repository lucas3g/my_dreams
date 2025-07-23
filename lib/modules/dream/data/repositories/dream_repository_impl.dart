import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import 'package:my_dreams/modules/dream/domain/entities/dream_exception.dart';

import '../../domain/entities/dream_entity.dart';
import '../../domain/repositories/dream_repository.dart';
import '../datasources/dream_datasource.dart';

@Injectable(as: DreamRepository)
class DreamRepositoryImpl implements DreamRepository {
  final DreamDatasource _datasource;

  DreamRepositoryImpl({required DreamDatasource datasource})
    : _datasource = datasource;

  @override
  Future<EitherOf<AppFailure, List<DreamEntity>>> getDreams(
    String userId,
  ) async {
    try {
      final dreams = await _datasource.getDreams(userId);
      return resolve(dreams);
    } catch (e) {
      return reject(DreamException(e.toString()));
    }
  }
}
