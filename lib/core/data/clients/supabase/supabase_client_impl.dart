import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_client_interface.dart';

@Singleton(as: ISupabaseClient)
class SupabaseClientImpl implements ISupabaseClient {
  final GoTrueClient _auth;
  final SupabaseClient _client;

  SupabaseClientImpl()
    : _client = Supabase.instance.client,
      _auth = Supabase.instance.client.auth;

  @override
  Future<AuthResponse> signInWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    required String accessToken,
  }) {
    return _auth.signInWithIdToken(
      provider: provider,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> uploadFile({
    required String bucket,
    required String path,
    required File file,
  }) async {
    await _client.storage.from(bucket).upload(path, file);
  }

  @override
  Future<void> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    await _client.from(table).insert(data);
  }

  @override
  Future<List<dynamic>> insertReturning({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    final response = await _client.from(table).insert(data).select();
    return response;
  }

  @override
  Future<List<dynamic>> select({
    required String table,
    required String columns,
    String? orderBy,
    Map<String, dynamic> filters = const {},
    int? limit,
    int? offset,
  }) async {
    final selectedColumns = columns.trim() == '*' ? '*' : columns;

    var query = _client.from(table).select(selectedColumns);

    if (filters.isNotEmpty) {
      query = query.eq(filters.keys.first, filters.values.first);
    }

    if (orderBy != null && orderBy.isNotEmpty) {
      query = query.order(orderBy);
    }

    if (limit != null) {
      final start = offset ?? 0;
      final end = start + limit - 1;
      query = query.range(start, end);
    }

    final data = await query;

    return data;
  }

  @override
  Future<void> update({
    required String table,
    required Map<String, dynamic> data,
    required Map<String, dynamic> filters,
  }) async {
    await _client
        .from(table)
        .update(data)
        .eq(filters.keys.first, filters.values.first);
  }

  @override
  Future<String> getImageUrl({required String bucket, required String path}) {
    return _client.storage.from(bucket).createSignedUrl(path, 60 * 60);
  }
}
