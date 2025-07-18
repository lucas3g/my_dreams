import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import 'package:my_dreams/modules/dream/domain/entities/dream_exception.dart';

import '../../domain/entities/dream_entity.dart';
import '../../domain/repositories/dream_repository.dart';
import '../datasources/gemini_datasource.dart';
import '../datasources/dream_datasource.dart';

@Injectable(as: DreamRepository)
class DreamRepositoryImpl implements DreamRepository {
  final DreamDatasource _datasource;
  final GeminiDatasource _gemini;

  DreamRepositoryImpl({
    required DreamDatasource datasource,
    required GeminiDatasource geminiDatasource,
  }) : _datasource = datasource,
       _gemini = geminiDatasource;

  @override
  Stream<EitherOf<AppFailure, DreamEntity>> analyzeDream({
    required String dreamText,
    required String userId,
  }) async* {
    final buffer = StringBuffer();
    try {
      await for (final chunk in _gemini.getMeaning(dreamText)) {
        buffer.write(chunk);
        yield resolve(
          DreamEntity(
            id: 0,
            userId: userId,
            message: dreamText,
            answer: buffer.toString(),
            createdAt: DateTime.now(),
          ),
        );
      }

      final dream = DreamEntity(
        id: 0,
        userId: userId,
        message: dreamText,
        answer: buffer.toString(),
        createdAt: DateTime.now(),
      );

      await _datasource.saveDream(dream);

      yield resolve(dream);
    } catch (e) {
      yield reject(DreamException(e.toString()));
    }
  }

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
