import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import '../../domain/entities/dream_entity.dart';
import '../../domain/repositories/dream_repository.dart';
import '../datasources/chatgpt_datasource.dart';
import '../datasources/dream_datasource.dart';

class DreamRepositoryImpl implements DreamRepository {
  final DreamDatasource _datasource;
  final ChatGptDatasource _chatGpt;

  DreamRepositoryImpl({
    required DreamDatasource datasource,
    required ChatGptDatasource chatGptDatasource,
  })  : _datasource = datasource,
        _chatGpt = chatGptDatasource;

  @override
  Future<EitherOf<AppFailure, DreamEntity>> analyzeDream({
    required String dreamText,
    required String userId,
  }) async {
    try {
      final meaning = await _chatGpt.getMeaning(dreamText);
      final dream = DreamEntity(
        id: 0,
        userId: userId,
        message: dreamText,
        answer: meaning,
        createdAt: DateTime.now(),
      );
      await _datasource.saveDream(dream);
      return resolve(dream);
    } catch (e) {
      return reject(AppFailure(e.toString()));
    }
  }

  @override
  Future<EitherOf<AppFailure, List<DreamEntity>>> getDreams(String userId) async {
    try {
      final dreams = await _datasource.getDreams(userId);
      return resolve(dreams);
    } catch (e) {
      return reject(AppFailure(e.toString()));
    }
  }
}
