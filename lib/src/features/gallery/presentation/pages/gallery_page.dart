import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/artworks_seed.dart';
import '../../../../core/state/theme_mode_provider.dart';
import '../../../artwork/presentation/pages/artwork_detail_page.dart';
import '../../../scan/presentation/pages/scan_page.dart';
import '../../../upload/presentation/pages/artwork_upload_page.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({super.key});

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final items = gallerySeedArtworks
        .map((e) => e.toMap())
        .where((e) {
          final q = _query.trim().toLowerCase();
          if (q.isEmpty) return true;
          return e['title'].toString().toLowerCase().contains(q) ||
              e['artist_name'].toString().toLowerCase().contains(q) ||
              e['category'].toString().toLowerCase().contains(q);
        })
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        Row(
          children: [
            const Spacer(),
            Text('GALLERY', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xFF1657C0), fontWeight: FontWeight.w800, letterSpacing: 2)),
            const Spacer(),
            IconButton(onPressed: () => ref.read(themeModeProvider.notifier).toggle(), icon: const Icon(Icons.dark_mode_outlined, color: Color(0xFF1657C0))),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: const InputDecoration(hintText: 'Search gallery', prefixIcon: Icon(Icons.search_rounded)),
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
        const SizedBox(height: 12),
        ...items.map((artwork) {
          final image = artwork['image_url'].toString();
          final title = artwork['title'].toString();
          final artist = artwork['artist_name'].toString();
          return GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ArtworkDetailPage(artwork: artwork))),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                    child: SizedBox(
                      width: 120,
                      height: 110,
                      child: Image.network(image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFE4E8F2))),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(artist, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text(artwork['category'].toString(), style: Theme.of(context).textTheme.bodySmall),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
