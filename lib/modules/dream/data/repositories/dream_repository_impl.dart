import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import 'package:my_dreams/modules/dream/data/adapters/dream_adapter.dart';
import 'package:my_dreams/modules/dream/domain/entities/dream_exception.dart';

import '../../domain/entities/dream_entity.dart';
import '../../domain/repositories/dream_repository.dart';
import '../datasources/dream_datasource.dart';
import '../datasources/gemini_datasource.dart';

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
  Future<EitherOf<AppFailure, DreamEntity>> analyzeDream({
    required String dreamText,
    required String userId,
  }) async {
    try {
      final answer = await _gemini.getMeaning(dreamText);
      //final imageUrl = await _gemini.createImage(answer);

      final dream = DreamAdapter.toEntity({
        'user_id': userId,
        'description': dreamText,
        'response_ai': answer,
        'image_url': '',
      });

      await _datasource.saveDream(dream);

      return resolve(dream);
    } catch (e) {
      return reject(DreamException(e.toString()));
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
