import 'package:flutter/material.dart';

import '../../../../core/widgets/smart_art_image.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  static const _groups = [
    (
      'Tersimpan',
      [
        'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988f1?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=1000&q=80',
      ],
    ),
    (
      'Favorit',
      [
        'https://images.unsplash.com/photo-1531913764164-f85c52e6e654?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1536924940846-227afb31e2a5?auto=format&fit=crop&w=1000&q=80',
      ],
    ),
    (
      'Hasil Edit',
      [
        'https://images.unsplash.com/photo-1579783928621-7a13d66a62f2?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1579783901586-d88db74b4fe4?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=1000&q=80',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Koleksi',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        itemBuilder: (context, i) =>
            _CollectionCard(title: _groups[i].$1, images: _groups[i].$2),
        separatorBuilder: (_, index) => const SizedBox(height: 14),
        itemCount: _groups.length,
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({required this.title, required this.images});

  final String title;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Row(
              children: images
                  .map(
                    (url) => Expanded(
                      child: SizedBox(
                        height: 110,
                        child: SmartArtImage(imageUrl: url, title: title),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${images.length} aset',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
