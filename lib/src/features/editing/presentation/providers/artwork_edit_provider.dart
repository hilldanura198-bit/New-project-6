import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/artwork_edit_state.dart';

final artworkEditProvider =
    StateNotifierProvider.autoDispose<ArtworkEditNotifier, ArtworkEditState>(
  (ref) => ArtworkEditNotifier(),
);

class ArtworkEditNotifier extends StateNotifier<ArtworkEditState> {
  ArtworkEditNotifier() : super(const ArtworkEditState());

  void toggleEditingMode(bool enabled) {
    state = state.copyWith(isEditingMode: enabled);
  }

  void setExposure(double value) {
    state = state.copyWith(exposure: value);
  }

  void setContrast(double value) {
    state = state.copyWith(contrast: value);
  }

  void setSaturation(double value) {
    state = state.copyWith(saturation: value);
  }

  void reset() {
    state = state.reset();
  }
}
