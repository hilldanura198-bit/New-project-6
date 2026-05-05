class ArtworkEditState {
  const ArtworkEditState({
    this.isEditingMode = true,
    this.exposure = 0.0,
    this.contrast = 1.0,
    this.saturation = 1.0,
    this.activeCategory = 'Adjust',
    this.selectedFilter = 'Natural',
    this.cropRatio = 0.75,
  });

  final bool isEditingMode;
  final double exposure;
  final double contrast;
  final double saturation;
  final String activeCategory;
  final String selectedFilter;
  final double cropRatio;

  ArtworkEditState reset() => const ArtworkEditState();

  List<double> toColorMatrix() {
    final double cv = contrast;
    final double sv = saturation;
    final double ev = exposure * 255;

    const double lumR = 0.2126;
    const double lumG = 0.7152;
    const double lumB = 0.0722;

    return <double>[
      cv * ((1 - sv) * lumR + sv), cv * ((1 - sv) * lumG), cv * ((1 - sv) * lumB), 0, ev,
      cv * ((1 - sv) * lumR), cv * ((1 - sv) * lumG + sv), cv * ((1 - sv) * lumB), 0, ev,
      cv * ((1 - sv) * lumR), cv * ((1 - sv) * lumG), cv * ((1 - sv) * lumB + sv), 0, ev,
      0, 0, 0, 1, 0,
    ];
  }

  ArtworkEditState copyWith({
    bool? isEditingMode,
    double? exposure,
    double? contrast,
    double? saturation,
    String? activeCategory,
    String? selectedFilter,
    double? cropRatio,
  }) {
    return ArtworkEditState(
      isEditingMode: isEditingMode ?? this.isEditingMode,
      exposure: exposure ?? this.exposure,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      activeCategory: activeCategory ?? this.activeCategory,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      cropRatio: cropRatio ?? this.cropRatio,
    );
  }
}
