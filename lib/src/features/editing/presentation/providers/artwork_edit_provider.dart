import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/artwork_edit_state.dart';

final artworkEditProvider =
    StateNotifierProvider.autoDispose<ArtworkEditNotifier, ArtworkEditState>(
      (ref) => ArtworkEditNotifier(),
    );

class ArtworkEditNotifier extends StateNotifier<ArtworkEditState> {
  ArtworkEditNotifier() : super(const ArtworkEditState());

  void setEditCategory(String category) {
    state = state.copyWith(activeCategory: category);
  }

  void toggleEditingMode(bool enabled) {
    state = state.copyWith(isEditingMode: enabled);
  }

  void setExposure(double value) => state = state.copyWith(exposure: value);
  void setContrast(double value) => state = state.copyWith(contrast: value);
  void setSaturation(double value) => state = state.copyWith(saturation: value);

  void applyFilter(String name) {
    switch (name) {
      case 'Dramatic':
        state = state.copyWith(
          selectedFilter: name,
          exposure: -0.02,
          contrast: 1.28,
          saturation: 1.2,
        );
        break;
      case 'Soft':
        state = state.copyWith(
          selectedFilter: name,
          exposure: 0.06,
          contrast: 0.92,
          saturation: 0.9,
        );
        break;
      case 'Vivid':
        state = state.copyWith(
          selectedFilter: name,
          exposure: 0.03,
          contrast: 1.1,
          saturation: 1.35,
        );
        break;
      case 'Mono':
        state = state.copyWith(
          selectedFilter: name,
          exposure: -0.01,
          contrast: 1.18,
          saturation: 0.1,
        );
        break;
      case 'Warm':
        state = state.copyWith(
          selectedFilter: name,
          exposure: 0.05,
          contrast: 1.02,
          saturation: 1.08,
        );
        break;
      default:
        state = state.copyWith(
          selectedFilter: 'Natural',
          exposure: 0,
          contrast: 1,
          saturation: 1,
        );
    }
  }

  void setCropRatio(double ratio) => state = state.copyWith(cropRatio: ratio);

  void reset() => state = const ArtworkEditState();
}
