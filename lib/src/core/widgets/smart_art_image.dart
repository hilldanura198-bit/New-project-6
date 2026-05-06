import 'package:flutter/material.dart';

class SmartArtImage extends StatelessWidget {
  const SmartArtImage({
    super.key,
    required this.imageUrl,
    required this.title,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final String title;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return _fallback(context);
    return Image.network(
      imageUrl,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return _loading(context);
      },
      errorBuilder: (context, error, stackTrace) => _fallback(context),
    );
  }

  Widget _loading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(90),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _fallback(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2E), Color(0xFF575762)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: onSurface.withAlpha(235),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
          ),
        ),
      ),
    );
  }
}
