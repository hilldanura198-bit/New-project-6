import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesRepository {
  FavoritesRepository(this._client);

  final SupabaseClient _client;

  User get _currentUser {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('User is not authenticated');
    }
    return user;
  }

  Stream<Set<String>> favoritesStream() {
    final user = _currentUser;
    return _client
        .from('favorites')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .map(
          (rows) => rows
              .map((row) => (row['artwork_id'] ?? '').toString())
              .where((id) => id.isNotEmpty)
              .toSet(),
        );
  }

  Future<void> saveFavorite(String artworkId) async {
    final user = _currentUser;
    await _client.from('favorites').upsert(
      {
        'user_id': user.id,
        'artwork_id': artworkId,
      },
      onConflict: 'user_id,artwork_id',
    );
  }

  Future<void> removeFavorite(String artworkId) async {
    final user = _currentUser;
    await _client
        .from('favorites')
        .delete()
        .eq('user_id', user.id)
        .eq('artwork_id', artworkId);
  }

  Future<List<Map<String, dynamic>>> fetchFavoriteArtworks(Set<String> ids) async {
    if (ids.isEmpty) {
      return const [];
    }

    final response = await _client
        .from('artworks')
        .select('*')
        .inFilter('id', ids.toList())
        .order('created_at', ascending: false);

    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
