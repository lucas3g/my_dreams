import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/data/clients/supabase/supabase_client_interface.dart';
import 'package:my_dreams/core/domain/entities/tables_db.dart';

import '../../domain/entities/dream_entity.dart';
import '../adapters/dream_adapter.dart';
import 'dream_datasource.dart';

@Injectable(as: DreamDatasource)
class DreamDatasourceImpl implements DreamDatasource {
  final ISupabaseClient _client;

  DreamDatasourceImpl({required ISupabaseClient supabaseClient})
    : _client = supabaseClient;

  @override
  Future<void> saveDream(DreamEntity dream) async {
    await _client.insert(
      table: TablesDB.userDreams.name,
      data: DreamAdapter.toMap(dream),
    );
  }

  @override
  Future<List<DreamEntity>> getDreams(String userId) async {
    final data = await _client.select(
      table: TablesDB.userDreams.name,
      columns: '*',
      orderBy: 'created_at',
      filters: {'user_id': userId},
    );

    return data
        .map((e) => DreamAdapter.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
