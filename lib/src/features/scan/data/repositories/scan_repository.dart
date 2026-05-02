import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

class ScanRepository {
  ScanRepository(this._client);

  final SupabaseClient _client;
  final _random = Random();

  Future<Map<String, dynamic>> simulateArtworkDetection() async {
    final response = await _client
        .from('artworks')
        .select('*')
        .order('created_at', ascending: false)
        .limit(24);

    final artworks = (response as List<dynamic>).cast<Map<String, dynamic>>();
    if (artworks.isEmpty) {
      throw StateError('No artworks available for scan simulation.');
    }

    final index = _random.nextInt(artworks.length);
    return artworks[index];
  }
}
