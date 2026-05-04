import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/scan_repository.dart';

final scanRepositoryProvider = Provider<ScanRepository>(
  (ref) => ScanRepository(Supabase.instance.client),
);

final scanControllerProvider = StateNotifierProvider<ScanController, ScanState>(
  (ref) => ScanController(ref.read(scanRepositoryProvider)),
);

class ScanState {
  const ScanState({
    this.isScanning = false,
    this.error,
    this.detectedArtwork,
  });

  final bool isScanning;
  final String? error;
  final Map<String, dynamic>? detectedArtwork;

  ScanState copyWith({
    bool? isScanning,
    String? error,
    Map<String, dynamic>? detectedArtwork,
  }) {
    return ScanState(
      isScanning: isScanning ?? this.isScanning,
      error: error,
      detectedArtwork: detectedArtwork ?? this.detectedArtwork,
    );
  }
}

class ScanController extends StateNotifier<ScanState> {
  ScanController(this._repository) : super(const ScanState());

  final ScanRepository _repository;

  Future<Map<String, dynamic>?> scanAndDetect() async {
    state = state.copyWith(isScanning: true, error: null);
    try {
      final artwork = await _repository.simulateArtworkDetection();
      state = state.copyWith(
        isScanning: false,
        error: null,
        detectedArtwork: artwork,
      );
      return artwork;
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        error: e.toString(),
      );
      return null;
    }
  }
}