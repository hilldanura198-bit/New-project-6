import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScanRepository {
  ScanRepository(this._client);

  final SupabaseClient _client;
  final _random = Random();

  Future<Map<String, dynamic>> simulateArtworkDetection() async {
    try {
      final response = await _client
          .from('artworks')
          .select('*')
          .order('created_at', ascending: false)
          .limit(24);

      final List<dynamic> data = response as List<dynamic>;
      
      if (data.isEmpty) {
        throw Exception('Tidak ada karya yang ditemukan di galeri.');
      }

      final artworks = data.map((item) => item as Map<String, dynamic>).toList();
      final index = _random.nextInt(artworks.length);
      final selected = artworks[index];

      return {
        'id': selected['id'],
        'title': selected['title'],
        'artist': selected['artist_name'],
        'imageUrl': selected['imageUrl'],
        'description': selected['description'],
        'year': selected['year'],
        'medium': selected['medium'],
        'category': selected['category'],
      };
      
    } on PostgrestException catch (e) {
      throw 'Kesalahan Database: ${e.message}';
    } catch (e) {
      throw 'Gagal mendeteksi karya. Pastikan koneksi internet aktif.';
    }
  }
}