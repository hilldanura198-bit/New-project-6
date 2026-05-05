import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/data/artworks_seed.dart';
import '../../../artwork/presentation/pages/artwork_detail_page.dart';
import '../../../scan/presentation/pages/scan_page.dart';
import '../../../upload/presentation/pages/artwork_upload_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String _query = '';

  List<Map<String, dynamic>> get _items {
    final q = _query.toLowerCase().trim();
    return gallerySeedArtworks
        .map((e) => e.toMap())
        .where((e) {
          if (q.isEmpty) return true;
          final title = (e['title'] ?? '').toString().toLowerCase();
          final artist = (e['artist_name'] ?? '').toString().toLowerCase();
          final category = (e['category'] ?? '').toString().toLowerCase();
          return title.contains(q) || artist.contains(q) || category.contains(q);
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Text('Gallery', style: Theme.of(context).textTheme.titleLarge),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: const InputDecoration(
                    hintText: 'Search by title, artist, category',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ScanPage())),
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        label: const Text('Scanner'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ArtworkUploadPage())),
                        icon: const Icon(Icons.cloud_upload_outlined),
                        label: const Text('Upload'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childCount: items.length,
            itemBuilder: (_, i) {
              final artwork = items[i];
              final title = (artwork['title'] ?? '').toString();
              final image = (artwork['image_url'] ?? '').toString();
              return GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ArtworkDetailPage(artwork: artwork))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Image.network(image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFE4E8F2))),
                      ),
                      const Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x05000000), Color(0x00000000), Color(0xAE000000)]),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 10,
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

