import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/user_profile.dart';
import '../../data/repositories/profile_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(supabaseClientProvider)),
);

final userProfileProvider = AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
  UserProfileNotifier.new,
);

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  @override
  Future<UserProfile> build() => _repository.fetchProfile();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.fetchProfile);
  }

  Future<void> saveProfile({
    required String username,
    required String bio,
  }) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.updateProfile(
        username: username,
        bio: bio,
        avatarUrl: current.avatarUrl,
      ),
    );
  }

  Future<void> uploadAvatar({
    required Uint8List bytes,
    required String fileExt,
  }) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final avatarUrl = await _repository.uploadAvatar(bytes: bytes, fileExt: fileExt);
      return _repository.updateProfile(
        username: current.username,
        bio: current.bio,
        avatarUrl: avatarUrl,
      );
    });
  }
}
