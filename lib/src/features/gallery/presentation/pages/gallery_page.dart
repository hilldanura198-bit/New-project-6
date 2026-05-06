import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/artworks_seed.dart';
import '../../../../core/state/theme_mode_provider.dart';
import '../../../../core/widgets/smart_art_image.dart';
import '../../../artwork/presentation/pages/artwork_detail_page.dart';
import '../../../artwork/presentation/widgets/favorite_heart_button.dart';
import '../../../scan/presentation/pages/scan_page.dart';
import '../../../upload/presentation/pages/artwork_upload_page.dart';
import '../providers/gallery_refresh_provider.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({super.key});

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  String _query = '';

  Future<List<Map<String, dynamic>>> _fetchUploadedArtworks() async {
    try {
      final response = await Supabase.instance.client
          .from('artworks')
          .select('id, title, artist_name, category, image_url')
          .order('created_at', ascending: false)
          .limit(30);
      return (response as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (_) {
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final refreshTick = ref.watch(galleryRefreshTickProvider);
    return FutureBuilder<List<Map<String, dynamic>>>(
      key: ValueKey(refreshTick),
      future: _fetchUploadedArtworks(),
      builder: (context, snapshot) {
        final uploaded = snapshot.data ?? const <Map<String, dynamic>>[];
        final items =
            [...uploaded, ...gallerySeedArtworks.map((e) => e.toMap())].where((
              e,
            ) {
              final q = _query.trim().toLowerCase();
              if (q.isEmpty) return true;
              return e['title'].toString().toLowerCase().contains(q) ||
                  e['artist_name'].toString().toLowerCase().contains(q) ||
                  e['category'].toString().toLowerCase().contains(q);
            }).toList();
        final hero = items.take(3).toList();
        final list = items.skip(3).toList();

        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bottomPadding = constraints.maxWidth < 420 ? 100.0 : 90.0;
              return ListView(
                padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Discover Art Work',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            ref.read(themeModeProvider.notifier).toggle(),
                        icon: const Icon(
                          Icons.dark_mode_outlined,
                          color: Color(0xFF1657C0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(
                      hintText: 'Search by title, artist, category...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const ScanPage(),
                            ),
                          ),
                          icon: const Icon(Icons.qr_code_scanner_rounded),
                          label: const Text('Scanner'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const ArtworkUploadPage(),
                              ),
                            );
                            if (mounted) setState(() {});
                          },
                          icon: const Icon(Icons.cloud_upload_outlined),
                          label: const Text('Upload'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...hero.map(
                    (artwork) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _FeatureGalleryCard(artwork: artwork),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...list.map(
                    (artwork) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ListGalleryCard(artwork: artwork),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _FeatureGalleryCard extends StatelessWidget {
  const _FeatureGalleryCard({required this.artwork});

  final Map<String, dynamic> artwork;

  @override
  Widget build(BuildContext context) {
    final title = artwork['title'].toString();
    final artist = artwork['artist_name'].toString();
    final id = artwork['id'].toString();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ArtworkDetailPage(artwork: artwork),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SmartArtImage(
                imageUrl: artwork['image_url'].toString(),
                title: title,
                fit: BoxFit.cover,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x12000000), Color(0xC4000000)],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: FavoriteHeartButton(artworkId: id),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Text(
                            artist,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white.withAlpha(45),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListGalleryCard extends StatelessWidget {
  const _ListGalleryCard({required this.artwork});

  final Map<String, dynamic> artwork;

  @override
  Widget build(BuildContext context) {
    final title = artwork['title'].toString();
    final artist = artwork['artist_name'].toString();
    final category = artwork['category'].toString();
    final id = artwork['id'].toString();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ArtworkDetailPage(artwork: artwork),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Theme.of(context).cardColor,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: SizedBox(
                  width: double.infinity,
                  child: SmartArtImage(
                    imageUrl: artwork['image_url'].toString(),
                    title: title,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x10000000), Color(0xC0000000)],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: FavoriteHeartButton(artworkId: id),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withAlpha(45),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 56,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(200),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        '#$category',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF1D2548),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
