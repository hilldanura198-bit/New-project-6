import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          IconButton(onPressed: notifier.reset, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: AspectRatio(
                  aspectRatio: state.cropRatio,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.black,
                      child: InteractiveViewer(
                        maxScale: state.activeCategory == 'Crop' ? 4 : 1,
                        minScale: 1,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix(state.toColorMatrix()),
                          child: _imageView(imageUrl),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _toolChip(context, notifier, state.activeCategory, 'Adjust', Icons.tune_rounded),
                _toolChip(context, notifier, state.activeCategory, 'Filter', Icons.filter_rounded),
                _toolChip(context, notifier, state.activeCategory, 'Crop', Icons.crop_rounded),
              ],
            ),
          ),
          if (state.activeCategory == 'Adjust')
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
              child: Column(
                children: [
                  PremiumAdjustmentSlider(label: 'Exposure', value: state.exposure, min: -0.5, max: 0.5, onChanged: notifier.setExposure),
                  const SizedBox(height: 10),
                  PremiumAdjustmentSlider(label: 'Contrast', value: state.contrast, min: 0.6, max: 1.6, onChanged: notifier.setContrast),
                  const SizedBox(height: 10),
                  PremiumAdjustmentSlider(label: 'Saturation', value: state.saturation, min: 0.0, max: 2.0, onChanged: notifier.setSaturation),
                ],
              ),
            ),
          if (state.activeCategory == 'Filter')
            SizedBox(
              height: 62,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  _filterButton(context, notifier, state.selectedFilter, 'Natural'),
                  _filterButton(context, notifier, state.selectedFilter, 'Soft'),
                  _filterButton(context, notifier, state.selectedFilter, 'Dramatic'),
                  _filterButton(context, notifier, state.selectedFilter, 'Vivid'),
                ],
              ),
            ),
          if (state.activeCategory == 'Crop')
            SizedBox(
              height: 62,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  _ratioButton(context, notifier, state.cropRatio, '3:4', 0.75),
                  _ratioButton(context, notifier, state.cropRatio, '1:1', 1),
                  _ratioButton(context, notifier, state.cropRatio, '4:5', 0.8),
                  _ratioButton(context, notifier, state.cropRatio, '9:16', 0.5625),
                ],
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

  Widget _toolChip(BuildContext context, ArtworkEditNotifier notifier, String current, String value, IconData icon) {
    final selected = current == value;
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => notifier.setEditCategory(value),
      avatar: Icon(icon, size: 18),
      label: Text(value),
    );
  }

  Widget _filterButton(BuildContext context, ArtworkEditNotifier notifier, String current, String value) {
    final selected = current == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: OutlinedButton(
        onPressed: () => notifier.applyFilter(value),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(66, 34),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: selected ? Theme.of(context).colorScheme.primary.withAlpha(25) : null,
        ),
        child: Text(value),
      ),
    );
  }

  Widget _ratioButton(BuildContext context, ArtworkEditNotifier notifier, double current, String label, double ratio) {
    final selected = (current - ratio).abs() < 0.01;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () => notifier.setCropRatio(ratio),
        style: OutlinedButton.styleFrom(backgroundColor: selected ? Theme.of(context).colorScheme.primary.withAlpha(25) : null),
        child: Text(label),
      ),
    );
  }

  Widget _imageView(String imageUrl) {
    if (imageUrl.isEmpty) return Container(color: const Color(0xFFEFE9DE));
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFEFE9DE)),
    );
  }
}

