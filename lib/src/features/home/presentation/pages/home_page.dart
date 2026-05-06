import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/artworks_seed.dart';
import '../../../../core/state/theme_mode_provider.dart';
import '../../../../core/widgets/smart_art_image.dart';
import '../../../artwork/presentation/pages/artwork_detail_page.dart';
import '../../../artwork/presentation/widgets/favorite_heart_button.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _selectedCategory = 'Modern';
  final _searchController = TextEditingController();
  final List<String> _history = [];

  static const _categories = ['Modern', 'Minimal', 'Botanical', 'Classic'];
  static const Map<String, List<Map<String, String>>> _categoryCatalog = {
    'Modern': [
      {'title': 'Silent Geometry', 'artist': 'A. Runa', 'image_url': 'https://images.unsplash.com/photo-1541701494587-cb58502866ab?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'City Echo', 'artist': 'D. Kieran', 'image_url': 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'Neon Balance', 'artist': 'C. Yara', 'image_url': 'https://images.unsplash.com/photo-1504198266285-165a79b27f07?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'Wide Strokes', 'artist': 'M. Leon', 'image_url': 'https://images.unsplash.com/photo-1576765607924-3f34465b72f7?auto=format&fit=crop&w=1200&q=80'},
    ],
    'Minimal': [
      {'title': 'Ivory Pause', 'artist': 'S. Taro', 'image_url': 'https://images.unsplash.com/photo-1473448912268-2022ce9509d8?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'Single Line', 'artist': 'K. Alen', 'image_url': 'https://images.unsplash.com/photo-1578926375605-eaf7559b1458?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'Quiet Form', 'artist': 'L. Wren', 'image_url': 'https://images.unsplash.com/photo-1459908676235-d5f02a50184b?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'Void Rhythm', 'artist': 'P. Mina', 'image_url': 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?auto=format&fit=crop&w=1200&q=80'},
    ],
    'Botanical': [
      {'title': 'Garden Manuscript', 'artist': 'V. Hale', 'image_url': 'https://images.unsplash.com/photo-1446071103084-c257b5f70672?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'Bloom Heritage', 'artist': 'I. Nara', 'image_url': 'https://images.unsplash.com/photo-1468327768560-75b778cbb551?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'Wild Petals', 'artist': 'R. Dia', 'image_url': 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'Forest Haze', 'artist': 'U. Moen', 'image_url': 'https://images.unsplash.com/photo-1462275646964-a0e3386b89fa?auto=format&fit=crop&w=1200&q=80'},
    ],
    'Classic': [
      {'title': 'Hall of Marble', 'artist': 'B. Caden', 'image_url': 'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'Royal Canvas', 'artist': 'J. Oryn', 'image_url': 'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'Museum Noon', 'artist': 'T. Soren', 'image_url': 'https://images.unsplash.com/photo-1561214115-f2f134cc4912?auto=format&fit=crop&w=1200&q=80'},
      {'title': 'Palace Frame', 'artist': 'E. Quinn', 'image_url': 'https://images.unsplash.com/photo-1529429617124-95b109e86bb8?auto=format&fit=crop&w=1200&q=80'},
    ],
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final username = (user?.userMetadata?['username'] ?? user?.email?.split('@').first ?? 'Collector').toString();
    final avatar = user?.userMetadata?['avatar_url']?.toString();

    final featured = (_categoryCatalog[_selectedCategory] ?? const [])
        .asMap()
        .entries
        .map((entry) => {
              'id': 'cat_${_selectedCategory}_${entry.key}',
              'title': entry.value['title']!,
              'artist_name': entry.value['artist']!,
              'image_url': entry.value['image_url']!,
              'category': _selectedCategory,
            })
        .toList();
    final trending = <Map<String, dynamic>>[
      ...homeSeedArtworks.map((e) => e.toMap()),
      ...gallerySeedArtworks.map((e) => e.toMap()),
    ].take(15).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('ARSIVA GALLERY ART', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFF1657C0), fontWeight: FontWeight.w800, letterSpacing: 1.4)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
                      icon: const Icon(Icons.dark_mode_outlined, color: Color(0xFF1657C0)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: avatar != null && avatar.isNotEmpty ? NetworkImage(avatar) : null,
                      child: avatar == null || avatar.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text('Hello, $username', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                    IconButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const NotificationDetailPage())),
                      icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1657C0)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  onSubmitted: (value) {
                    final q = value.trim();
                    if (q.isEmpty) return;
                    setState(() {
                      _history.remove(q);
                      _history.insert(0, q);
                      if (_history.length > 5) _history.removeLast();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search artworks',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                if (_history.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 6,
                      children: _history.map((e) => Chip(label: Text(e))).toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                SizedBox(
                  height: 174,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) => _HeroTripCard(artwork: trending[i]),
                    separatorBuilder: (_, i) => const SizedBox(width: 10),
                    itemCount: trending.length > 5 ? 5 : trending.length,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((c) {
                      return ChoiceChip(
                        label: Text(
                          c,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        selected: _selectedCategory == c,
                        onSelected: (_) => setState(() => _selectedCategory = c),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childCount: featured.length,
            itemBuilder: (_, i) => _ArtworkCard(artwork: featured[i]),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gallery Paling Trending', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text('15 artworks', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: .72,
            ),
            itemCount: trending.length,
            itemBuilder: (_, i) => _TrendingCard(artwork: trending[i]),
          ),
        ),
      ],
    );
  }
}

class _ArtworkCard extends StatelessWidget {
  const _ArtworkCard({required this.artwork});
  final Map<String, dynamic> artwork;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (artwork['image_url'] ?? '').toString();
    final title = (artwork['title'] ?? '').toString();
    final artist = (artwork['artist_name'] ?? '').toString();
    final id = artwork['id'].toString();

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ArtworkDetailPage(artwork: artwork))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: SmartArtImage(
                imageUrl: imageUrl,
                title: title,
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x12000000), Color(0x00000000), Color(0xB0000000)])),
              ),
            ),
            Positioned(top: 8, right: 8, child: FavoriteHeartButton(artworkId: id)),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(artist, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({required this.artwork});
  final Map<String, dynamic> artwork;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ArtworkDetailPage(artwork: artwork))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: SmartArtImage(
                  imageUrl: artwork['image_url'].toString(),
                  title: artwork['title'].toString(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                artwork['title'].toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroTripCard extends StatelessWidget {
  const _HeroTripCard({required this.artwork});

  final Map<String, dynamic> artwork;

  @override
  Widget build(BuildContext context) {
    final imageUrl = artwork['image_url'].toString();
    final title = artwork['title'].toString();
    final artist = artwork['artist_name'].toString();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => ArtworkDetailPage(artwork: artwork)),
      ),
      child: SizedBox(
        width: 240,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SmartArtImage(imageUrl: imageUrl, title: title),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x33000000), Color(0xBA000000)],
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
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

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});

  static const _fallbackNotices = [
    'Karya baru "VELVET BLOOM" telah ditambahkan.',
    'Favorit Anda mendapat pembaruan metadata.',
    'Upload Anda berhasil dipublikasikan.',
    'Koleksi trending minggu ini telah diperbarui.',
    'Tema Dark Mode aktif di akun Anda.',
  ];

  Future<List<String>> _loadNotices() async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return _fallbackNotices;
    try {
      final rows = await client
          .from('notifications')
          .select('title, message')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(20);
      final notices = rows
          .map<String>((row) {
            final title = (row['title'] ?? '').toString().trim();
            final message = (row['message'] ?? '').toString().trim();
            if (title.isEmpty && message.isEmpty) return '';
            return title.isEmpty ? message : '$title - $message';
          })
          .where((e) => e.isNotEmpty)
          .toList();
      return notices.isEmpty ? _fallbackNotices : notices;
    } catch (_) {
      return _fallbackNotices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Notifikasi')),
      body: FutureBuilder<List<String>>(
        future: _loadNotices(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notices = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, i) => ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: Text(notices[i]),
              subtitle: const Text('Baru saja'),
            ),
            separatorBuilder: (_, i) => const Divider(height: 1),
            itemCount: notices.length,
          );
        },
      ),
    );
  }
}
