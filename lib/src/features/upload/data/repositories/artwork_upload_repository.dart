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
      throw const AuthException('Sesi berakhir, silakan login kembali');
    }
    return user;
  }

  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileExt,
  }) async {
    try {
      final user = _currentUser;
      final safeExt = fileExt.isEmpty ? 'jpg' : fileExt;
      final path =
          '${user.id}/artwork_${DateTime.now().millisecondsSinceEpoch}.$safeExt';

      await _client.storage
          .from(_bucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: 'image/$safeExt',
              upsert: false,
            ),
          );

      return _client.storage.from(_bucket).getPublicUrl(path);
    } catch (e) {
      throw Exception('Gagal mengunggah gambar: ${e.toString()}');
    }
  }

  Future<void> saveArtworkMetadata({
    required ArtworkUploadDraft draft,
    required String imageUrl,
  }) async {
    try {
      final user = _currentUser;
      final parsedYear = int.tryParse(draft.year.trim()) ?? DateTime.now().year;

      await _client.from('artworks').insert({
        'title': draft.title.trim(),
        'artist_name': draft.artist.trim(),
        'year': parsedYear,
        'medium': draft.medium.trim(),
        'description': draft.description.trim(),
        'category': draft.category.trim(),
        'image_url': imageUrl,
        'user_id': user.id,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Gagal menyimpan data karya: ${e.toString()}');
    }
  }
}
