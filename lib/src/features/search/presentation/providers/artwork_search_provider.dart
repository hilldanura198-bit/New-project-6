import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/artwork_search_repository.dart';

final artworkSearchRepositoryProvider = Provider<ArtworkSearchRepository>(
  (ref) => ArtworkSearchRepository(Supabase.instance.client),
);

final artworkSearchProvider =
    StateNotifierProvider<ArtworkSearchNotifier, ArtworkSearchState>(
  (ref) => ArtworkSearchNotifier(ref.read(artworkSearchRepositoryProvider))..start(),
);

class ArtworkSearchState {
  const ArtworkSearchState({
    this.allArtworks = const [],
    this.filteredArtworks = const [],
    this.query = '',
    this.selectedCategory,
    this.selectedArtist,
    this.categories = const [],
    this.artists = const [],
    this.error,
  });

  final List<Map<String, dynamic>> allArtworks;
  final List<Map<String, dynamic>> filteredArtworks;
  final String query;
  final String? selectedCategory;
  final String? selectedArtist;
  final List<String> categories;
  final List<String> artists;
  final String? error;

  ArtworkSearchState copyWith({
    List<Map<String, dynamic>>? allArtworks,
    List<Map<String, dynamic>>? filteredArtworks,
    String? query,
    String? selectedCategory,
    String? selectedArtist,
    List<String>? categories,
    List<String>? artists,
    String? error,
    bool clearCategory = false,
    bool clearArtist = false,
  }) {
    return ArtworkSearchState(
      allArtworks: allArtworks ?? this.allArtworks,
      filteredArtworks: filteredArtworks ?? this.filteredArtworks,
      query: query ?? this.query,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedArtist: clearArtist ? null : (selectedArtist ?? this.selectedArtist),
      categories: categories ?? this.categories,
      artists: artists ?? this.artists,
      error: error,
    );
  }
}

class ArtworkSearchNotifier extends StateNotifier<ArtworkSearchState> {
  ArtworkSearchNotifier(this._repository) : super(const ArtworkSearchState());

  final ArtworkSearchRepository _repository;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  void start() {
    _subscription ??= _repository.streamArtworks().listen(
      (artworks) {
        final categories = artworks
            .map((item) => (item['category'] ?? '').toString().trim())
            .where((item) => item.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

        final artists = artworks
            .map((item) => (item['artist_name'] ?? '').toString().trim())
            .where((item) => item.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

        final next = state.copyWith(
          allArtworks: artworks,
          categories: categories,
          artists: artists,
          error: null,
        );
        state = _applyFilters(next);
      },
      onError: (Object error, StackTrace stackTrace) {
        state = state.copyWith(error: 'Unable to load artworks.');
      },
    );
  }

  void setQuery(String value) {
    state = _applyFilters(state.copyWith(query: value));
  }

  void setCategory(String? value) {
    state = _applyFilters(
      value == null || value.isEmpty
          ? state.copyWith(clearCategory: true)
          : state.copyWith(selectedCategory: value),
    );
  }

  void setArtist(String? value) {
    state = _applyFilters(
      value == null || value.isEmpty
          ? state.copyWith(clearArtist: true)
          : state.copyWith(selectedArtist: value),
    );
  }

  void clearFilters() {
    state = _applyFilters(
      state.copyWith(
        query: '',
        clearCategory: true,
        clearArtist: true,
      ),
    );
  }

  ArtworkSearchState _applyFilters(ArtworkSearchState base) {
    final q = base.query.trim().toLowerCase();
    final category = base.selectedCategory?.toLowerCase();
    final artist = base.selectedArtist?.toLowerCase();

    final filtered = base.allArtworks.where((artwork) {
      final title = (artwork['title'] ?? '').toString().toLowerCase();
      final artistName = (artwork['artist_name'] ?? '').toString().toLowerCase();
      final categoryName = (artwork['category'] ?? '').toString().toLowerCase();

      final queryMatch =
          q.isEmpty || title.contains(q) || artistName.contains(q) || categoryName.contains(q);
      final categoryMatch = category == null || category.isEmpty || categoryName == category;
      final artistMatch = artist == null || artist.isEmpty || artistName == artist;

      return queryMatch && categoryMatch && artistMatch;
    }).toList();

    return base.copyWith(filteredArtworks: filtered);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
