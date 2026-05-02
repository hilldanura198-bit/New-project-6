import 'dart:math' as math;

class ArtworkEditState {
  const ArtworkEditState({
    this.isEditingMode = true,
    this.exposure = 0,
    this.contrast = 1,
    this.saturation = 1,
  });

  final bool isEditingMode;
  final double exposure;
  final double contrast;
  final double saturation;

  ArtworkEditState copyWith({
    bool? isEditingMode,
    double? exposure,
    double? contrast,
    double? saturation,
  }) {
    return ArtworkEditState(
      isEditingMode: isEditingMode ?? this.isEditingMode,
      exposure: exposure ?? this.exposure,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
    );
  }

  ArtworkEditState reset() => const ArtworkEditState();

  List<double> toColorMatrix() {
    final c = contrast;
    final s = saturation;
    final e = exposure * 255;

    final invSat = 1 - s;
    final r = 0.2126 * invSat;
    final g = 0.7152 * invSat;
    final b = 0.0722 * invSat;

    final saturationMatrix = <double>[
      r + s, g, b, 0, 0,
      r, g + s, b, 0, 0,
      r, g, b + s, 0, 0,
      0, 0, 0, 1, 0,
    ];

    final t = (1 - c) * 128;
    final contrastMatrix = <double>[
      c, 0, 0, 0, t,
      0, c, 0, 0, t,
      0, 0, c, 0, t,
      0, 0, 0, 1, 0,
    ];

    final exposureMatrix = <double>[
      1, 0, 0, 0, e,
      0, 1, 0, 0, e,
      0, 0, 1, 0, e,
      0, 0, 0, 1, 0,
    ];

    return _multiplyColorMatrices(
      exposureMatrix,
      _multiplyColorMatrices(contrastMatrix, saturationMatrix),
    );
  }

  List<double> _multiplyColorMatrices(List<double> a, List<double> b) {
    final result = List<double>.filled(20, 0);
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 5; col++) {
        final index = row * 5 + col;
        result[index] =
            a[row * 5] * b[col] +
            a[row * 5 + 1] * b[5 + col] +
            a[row * 5 + 2] * b[10 + col] +
            a[row * 5 + 3] * b[15 + col] +
            (col == 4 ? a[row * 5 + 4] : 0);
      }
    }

    for (var i = 0; i < result.length; i++) {
      if (result[i].isNaN || result[i].isInfinite) {
        result[i] = 0;
      }
      result[i] = math.max(-255, math.min(255, result[i]));
    }

    return result;
  }
}
