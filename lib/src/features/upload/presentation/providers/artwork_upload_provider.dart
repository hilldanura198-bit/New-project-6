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
    // Validasi draft dari model
    final errors = draft.validate();
    if (errors.isNotEmpty) {
      state = state.copyWith(error: errors.first);
      return false;
    }

    // Mulai Loading
    state = const ArtworkUploadState(isUploading: true, progress: 0.1);

    try {
      // Step 1: Upload File Gambar ke Storage
      state = state.copyWith(progress: 0.3);
      final imageUrl = await _repository.uploadImage(
        bytes: imageBytes,
        fileExt: fileExt,
      );

      // Step 2: Simpan Metadata ke Database
      state = state.copyWith(progress: 0.7);
      await _repository.saveArtworkMetadata(draft: draft, imageUrl: imageUrl);

      // Selesai
      state = const ArtworkUploadState(
        isUploading: false,
        progress: 1.0,
        successMessage: 'Artwork uploaded successfully.',
      );
      return true;
    } catch (e) {
      // Jika terjadi error (misal koneksi atau Supabase bermasalah)
      state = ArtworkUploadState(
        isUploading: false,
        progress: 0,
        error: e.toString().contains('PostgrestException')
            ? 'Gagal menyimpan data ke database.'
            : 'Gagal mengupload gambar. Periksa koneksi internet.',
      );
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}
