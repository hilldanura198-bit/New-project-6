import 'package:cached_network_image/cached_network_image.dart';
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

  static const Map<String, String> _fallbackByTitle = {
    'STARRY NIGHT':
        'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1400&q=80',
    'SUNFLOWERS':
        'https://images.unsplash.com/photo-1470509037663-253afd7f0f51?auto=format&fit=crop&w=1400&q=80',
    'ALMOND BLOSSOM':
        'https://images.unsplash.com/photo-1455659817273-f96807779a8a?auto=format&fit=crop&w=1400&q=80',
    'THE KISS':
        'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=1400&q=80',
    'THE SOWER':
        'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1400&q=80',
    'SUNFLOWER STUDY':
        'https://images.unsplash.com/photo-1470509037663-253afd7f0f51?auto=format&fit=crop&w=1400&q=80',
    'THE SLEEPING GYPSY':
        'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?auto=format&fit=crop&w=1400&q=80',
    'THE SWING':
        'https://images.unsplash.com/photo-1561214115-f2f134cc4912?auto=format&fit=crop&w=1400&q=80',
    'THE NIGHT WATCH':
        'https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=1400&q=80',
    'THE HAY WAIN':
        'https://images.unsplash.com/photo-1462275646964-a0e3386b89fa?auto=format&fit=crop&w=1400&q=80',
    'DANCE AT LE MOULIN DE LA GALETTE':
        'https://images.unsplash.com/photo-1541701494587-cb58502866ab?auto=format&fit=crop&w=1400&q=80',
    'THE PROMENADE':
        'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?auto=format&fit=crop&w=1400&q=80',
    'THE GREAT WAVE':
        'https://images.unsplash.com/photo-1579783928621-7a13d66a62f2?auto=format&fit=crop&w=1400&q=80',
  };

  String get _fallbackUrl =>
      _fallbackByTitle[title.toUpperCase()] ??
      'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=1400&q=80';

  @override
  Widget build(BuildContext context) {
    final primary = imageUrl.trim().isEmpty ? _fallbackUrl : imageUrl.trim();
    return ClipRect(
      child: CachedNetworkImage(
        imageUrl: primary,
        fit: BoxFit.cover,
        width: double.infinity,
        fadeInDuration: const Duration(milliseconds: 150),
        fadeOutDuration: const Duration(milliseconds: 100),
        placeholder: (context, url) => _loading(),
        errorWidget: (context, url, error) => CachedNetworkImage(
          imageUrl: _fallbackUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, _) => _loading(),
          errorWidget: (context, url, error) => _ultimateFallback(),
        ),
      ),
    );
  }

  Widget _loading() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8EEF9), Color(0xFFD4E1F8)],
        ),
      ),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _ultimateFallback() {
    return Image.asset(
      'assets/images/art_fallback.jpg',
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }
}
