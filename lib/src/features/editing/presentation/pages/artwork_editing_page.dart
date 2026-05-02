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
    final filterMatrix = state.toColorMatrix();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artwork Editing'),
        actions: [
          TextButton.icon(
            onPressed: notifier.reset,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reset'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? const [Color(0xFF1A1A19), Color(0xFF222220)]
                        : const [Color(0xFFFFFFFF), Color(0xFFF5EFE3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x13000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Switch.adaptive(
                      value: state.isEditingMode,
                      onChanged: notifier.toggleEditingMode,
                    ),
                    Text(
                      'Editing Mode',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: ColoredBox(
                    color: const Color(0xFF111110),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: state.isEditingMode
                              ? ColorFiltered(
                                  key: ValueKey<String>(
                                    '${state.exposure}-${state.contrast}-${state.saturation}',
                                  ),
                                  colorFilter: ColorFilter.matrix(filterMatrix),
                                  child: _imageView(imageUrl),
                                )
                              : _imageView(imageUrl),
                        ),
                        Positioned(
                          left: 14,
                          top: 14,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.48),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              child: Text(
                                'Live Preview',
                                style: TextStyle(
                                  color: Color(0xFFF6E8CB),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: state.isEditingMode ? 1 : 0.4,
                child: IgnorePointer(
                  ignoring: !state.isEditingMode,
                  child: Column(
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
                        min: 0,
                        max: 2,
                        onChanged: notifier.setSaturation,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageView(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const ColoredBox(color: Color(0xFFEFE9DE));
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        return const ColoredBox(color: Color(0xFFEFE9DE));
      },
    );
  }
}
