import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';

class ProfileRepository {
  ProfileRepository(this._client);

  final SupabaseClient _client;
  static const _bucket = 'avatars';

  User get _currentUser {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('User is not authenticated');
    }
    return user;
  }

  Future<UserProfile> fetchProfile() async {
    final user = _currentUser;
    final response = await _client
        .from('profiles')
        .select('id,email,username,bio,avatar_url')
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      final fallbackUsername = user.email?.split('@').first ?? 'Collector';
      await _client.from('profiles').upsert({
        'id': user.id,
        'email': user.email,
        'username': fallbackUsername,
        'bio': '',
      });

      return UserProfile(
        id: user.id,
        email: user.email ?? '',
        username: fallbackUsername,
        bio: '',
        avatarUrl: null,
      );
    }

    return UserProfile.fromMap(response);
  }

  Future<UserProfile> updateProfile({
    required String username,
    required String bio,
    String? avatarUrl,
  }) async {
    final user = _currentUser;

    await _client.from('profiles').upsert({
      'id': user.id,
      'email': user.email,
      'username': username,
      'bio': bio,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    });

    final profile = await fetchProfile();
    return profile;
  }

  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String fileExt,
  }) async {
    final user = _currentUser;
    final safeExt = fileExt.isEmpty ? 'jpg' : fileExt;
    final filePath = '${user.id}/avatar_${DateTime.now().millisecondsSinceEpoch}.$safeExt';

    await _client.storage.from(_bucket).uploadBinary(
          filePath,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from(_bucket).getPublicUrl(filePath);
  }
}
