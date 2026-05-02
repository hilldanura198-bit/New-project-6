import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/artwork_upload_draft.dart';
import '../../data/repositories/artwork_upload_repository.dart';

final artworkUploadRepositoryProvider = Provider<ArtworkUploadRepository>(
  (ref) => ArtworkUploadRepository(Supabase.instance.client),
);

final artworkUploadProvider =
    StateNotifierProvider<ArtworkUploadNotifier, ArtworkUploadState>(
  (ref) => ArtworkUploadNotifier(ref.read(artworkUploadRepositoryProvider)),
);

class ArtworkUploadState {
  const ArtworkUploadState({
    this.isUploading = false,
    this.progress = 0,
    this.error,
    this.successMessage,
  });

  final bool isUploading;
  final double progress;
  final String? error;
  final String? successMessage;

  ArtworkUploadState copyWith({
    bool? isUploading,
    double? progress,
    String? error,
    String? successMessage,
  }) {
    return ArtworkUploadState(
      isUploading: isUploading ?? this.isUploading,
      progress: progress ?? this.progress,
      error: error,
      successMessage: successMessage,
    );
  }
}

class ArtworkUploadNotifier extends StateNotifier<ArtworkUploadState> {
  ArtworkUploadNotifier(this._repository) : super(const ArtworkUploadState());

  final ArtworkUploadRepository _repository;

  Future<bool> uploadArtwork({
    required ArtworkUploadDraft draft,
    required Uint8List imageBytes,
    required String fileExt,
  }) async {
    final errors = draft.validate();
    if (errors.isNotEmpty) {
      state = state.copyWith(error: errors.first);
      return false;
    }

    state = const ArtworkUploadState(isUploading: true, progress: 0.1);

    try {
      state = state.copyWith(progress: 0.45);
      final imageUrl = await _repository.uploadImage(
        bytes: imageBytes,
        fileExt: fileExt,
      );

      state = state.copyWith(progress: 0.8);
      await _repository.saveArtworkMetadata(draft: draft, imageUrl: imageUrl);

      state = const ArtworkUploadState(
        isUploading: false,
        progress: 1,
        successMessage: 'Artwork uploaded successfully.',
      );
      return true;
    } catch (error) {
      state = const ArtworkUploadState(
        isUploading: false,
        progress: 0,
      ).copyWith(error: 'Upload failed. Please try again.');
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}
