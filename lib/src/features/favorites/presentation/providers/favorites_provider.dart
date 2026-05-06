import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(Supabase.instance.client),
);

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>(
      (ref) =>
          FavoritesNotifier(ref.read(favoritesRepositoryProvider))..start(),
    );

final favoriteArtworksProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final ids = ref.watch(favoritesProvider).ids;
  return ref.read(favoritesRepositoryProvider).fetchFavoriteArtworks(ids);
});

class FavoritesState {
  const FavoritesState({
    this.ids = const <String>{},
    this.pendingIds = const <String>{},
    this.error,
  });

  final Set<String> ids;
  final Set<String> pendingIds;
  final String? error;

  FavoritesState copyWith({
    Set<String>? ids,
    Set<String>? pendingIds,
    String? error,
  }) {
    return FavoritesState(
      ids: ids ?? this.ids,
      pendingIds: pendingIds ?? this.pendingIds,
      error: error,
    );
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier(this._repository) : super(const FavoritesState());

  final FavoritesRepository _repository;
  StreamSubscription<Set<String>>? _subscription;

  void start() {
    _subscription ??= _repository.favoritesStream().listen(
      (ids) {
        state = state.copyWith(ids: ids, error: null);
      },
      onError: (Object error, StackTrace stackTrace) {
        state = state.copyWith(error: error.toString());
      },
    );
  }

  bool isFavorite(String artworkId) => state.ids.contains(artworkId);

  bool isPending(String artworkId) => state.pendingIds.contains(artworkId);

  Future<void> toggleFavorite(String artworkId) async {
    if (isPending(artworkId)) {
      return;
    }

    final wasFavorite = isFavorite(artworkId);
    final optimisticIds = {...state.ids};
    if (wasFavorite) {
      optimisticIds.remove(artworkId);
    } else {
      optimisticIds.add(artworkId);
    }

    state = state.copyWith(
      ids: optimisticIds,
      pendingIds: {...state.pendingIds, artworkId},
      error: null,
    );

    try {
      if (wasFavorite) {
        await _repository.removeFavorite(artworkId);
      } else {
        await _repository.saveFavorite(artworkId);
      }
    } catch (error) {
      final rollbackIds = {...state.ids};
      if (wasFavorite) {
        rollbackIds.add(artworkId);
      } else {
        rollbackIds.remove(artworkId);
      }

      state = state.copyWith(
        ids: rollbackIds,
        error: 'Unable to update favorites. Please try again.',
      );
    } finally {
      final updatedPending = {...state.pendingIds}..remove(artworkId);
      state = state.copyWith(pendingIds: updatedPending);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
