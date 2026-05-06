import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/smart_art_image.dart';
import '../providers/artwork_edit_provider.dart';
import '../widgets/premium_adjustment_slider.dart';

class ArtworkEditingPage extends ConsumerWidget {
  const ArtworkEditingPage({super.key, required this.artwork});

  final Map<String, dynamic> artwork;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(artworkEditProvider);
    final notifier = ref.read(artworkEditProvider.notifier);

    final title = (artwork['title'] ?? 'Untitled').toString();
    final imageUrl = (artwork['image_url'] ?? '').toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Editing', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: notifier.reset,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: Column(
                  children: [
                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeInOut,
                        constraints: const BoxConstraints(maxHeight: 420),
                        child: AspectRatio(
                          aspectRatio: state.cropRatio,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              color: Colors.black,
                              child: InteractiveViewer(
                                maxScale: state.activeCategory == 'Crop'
                                    ? 4
                                    : 1,
                                minScale: 1,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.matrix(
                                    state.toColorMatrix(),
                                  ),
                                  child: SizedBox.expand(
                                    child: _imageView(imageUrl, title),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _toolChip(
                            context,
                            notifier,
                            state.activeCategory,
                            'Adjust',
                            Icons.tune_rounded,
                          ),
                          _toolChip(
                            context,
                            notifier,
                            state.activeCategory,
                            'Filter',
                            Icons.filter_rounded,
                          ),
                          _toolChip(
                            context,
                            notifier,
                            state.activeCategory,
                            'Crop',
                            Icons.crop_rounded,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (state.activeCategory == 'Adjust')
                      Column(
                        children: [
                          PremiumAdjustmentSlider(
                            label: 'Exposure',
                            value: state.exposure,
                            min: -0.5,
                            max: 0.5,
                            onChanged: notifier.setExposure,
                          ),
                          const SizedBox(height: 10),
                          PremiumAdjustmentSlider(
                            label: 'Contrast',
                            value: state.contrast,
                            min: 0.6,
                            max: 1.6,
                            onChanged: notifier.setContrast,
                          ),
                          const SizedBox(height: 10),
                          PremiumAdjustmentSlider(
                            label: 'Saturation',
                            value: state.saturation,
                            min: 0.0,
                            max: 2.0,
                            onChanged: notifier.setSaturation,
                          ),
                        ],
                      ),
                    if (state.activeCategory == 'Filter')
                      SizedBox(
                        height: 56,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _filterButton(
                              context,
                              notifier,
                              state.selectedFilter,
                              'Natural',
                            ),
                            _filterButton(
                              context,
                              notifier,
                              state.selectedFilter,
                              'Soft',
                            ),
                            _filterButton(
                              context,
                              notifier,
                              state.selectedFilter,
                              'Dramatic',
                            ),
                            _filterButton(
                              context,
                              notifier,
                              state.selectedFilter,
                              'Vivid',
                            ),
                            _filterButton(
                              context,
                              notifier,
                              state.selectedFilter,
                              'Mono',
                            ),
                            _filterButton(
                              context,
                              notifier,
                              state.selectedFilter,
                              'Warm',
                            ),
                          ],
                        ),
                      ),
                    if (state.activeCategory == 'Crop')
                      SizedBox(
                        height: 56,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _ratioButton(
                              context,
                              notifier,
                              state.cropRatio,
                              'Free',
                              1.3,
                            ),
                            _ratioButton(
                              context,
                              notifier,
                              state.cropRatio,
                              '1:1',
                              1,
                            ),
                            _ratioButton(
                              context,
                              notifier,
                              state.cropRatio,
                              '4:5',
                              0.8,
                            ),
                            _ratioButton(
                              context,
                              notifier,
                              state.cropRatio,
                              '16:9',
                              1.78,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Simpan Perubahan untuk $title'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolChip(
    BuildContext context,
    ArtworkEditNotifier notifier,
    String current,
    String value,
    IconData icon,
  ) {
    final selected = current == value;
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => notifier.setEditCategory(value),
      avatar: Icon(icon, size: 18),
      label: Text(value),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _filterButton(
    BuildContext context,
    ArtworkEditNotifier notifier,
    String current,
    String value,
  ) {
    final selected = current == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: OutlinedButton(
        onPressed: () => notifier.applyFilter(value),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(52, 30),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: selected
              ? Theme.of(context).colorScheme.primary.withAlpha(25)
              : null,
        ),
        child: Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _ratioButton(
    BuildContext context,
    ArtworkEditNotifier notifier,
    double current,
    String label,
    double ratio,
  ) {
    final selected = (current - ratio).abs() < 0.01;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () => notifier.setCropRatio(ratio),
        style: OutlinedButton.styleFrom(
          backgroundColor: selected
              ? Theme.of(context).colorScheme.primary.withAlpha(25)
              : null,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _imageView(String imageUrl, String title) {
    return SmartArtImage(imageUrl: imageUrl, title: title, fit: BoxFit.cover);
  }
}
