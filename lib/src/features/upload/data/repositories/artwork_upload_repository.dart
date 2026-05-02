import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/artwork_upload_draft.dart';

class ArtworkUploadRepository {
  ArtworkUploadRepository(this._client);

  final SupabaseClient _client;
  static const _bucket = 'artworks';

  User get _currentUser {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('User is not authenticated');
    }
    return user;
  }

  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileExt,
  }) async {
    final user = _currentUser;
    final safeExt = fileExt.isEmpty ? 'jpg' : fileExt;
    final path = '${user.id}/artwork_${DateTime.now().millisecondsSinceEpoch}.$safeExt';

    await _client.storage.from(_bucket).uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: false),
        );

    return _client.storage.from(_bucket).getPublicUrl(path);
  }

  Future<void> saveArtworkMetadata({
    required ArtworkUploadDraft draft,
    required String imageUrl,
  }) async {
    final user = _currentUser;
    final parsedYear = int.parse(draft.year.trim());

    await _client.from('artworks').insert({
      'title': draft.title.trim(),
      'artist_name': draft.artist.trim(),
      'year': parsedYear,
      'medium': draft.medium.trim(),
      'description': draft.description.trim(),
      'category': draft.category.trim(),
      'image_url': imageUrl,
      'user_id': user.id,
    });
  }
}
