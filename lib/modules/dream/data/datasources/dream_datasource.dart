import '../../domain/entities/dream_entity.dart';

abstract class DreamDatasource {
  Future<void> saveDream(DreamEntity dream);

  Future<List<DreamEntity>> getDreams(String userId);
}
