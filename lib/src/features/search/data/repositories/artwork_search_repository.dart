import 'package:supabase_flutter/supabase_flutter.dart';

class ArtworkSearchRepository {
  ArtworkSearchRepository(this._client);

  final SupabaseClient _client;

  Stream<List<Map<String, dynamic>>> streamArtworks() {
    return _client
        .from('artworks')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }
}
