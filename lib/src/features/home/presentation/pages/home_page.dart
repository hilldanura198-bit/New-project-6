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
  int _heroIndex = 0;
  String _selectedCategory = 'Modern';
  final _heroController = PageController();
  final _searchController = TextEditingController();
  final List<String> _history = [];
  static const _categories = ['Modern', 'Classic', 'Botanical', 'Abstract'];

  static const Map<String, List<Map<String, String>>> _categoryCatalog = {
    'Modern': [
      {
        'title': 'Sunflower Study',
        'artist': 'Van Gogh',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/4/40/Vincent_Willem_van_Gogh_128.jpg',
      },
      {
        'title': 'Starry Night',
        'artist': 'Van Gogh',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/e/ea/The_Starry_Night.JPG',
      },
      {
        'title': 'The Sower',
        'artist': 'Van Gogh',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/9/9d/Vincent_van_Gogh_-_The_Sower_-_Google_Art_Project.jpg',
      },
      {
        'title': 'Almond Blossom',
        'artist': 'Van Gogh',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/3/30/Vincent_van_Gogh_-_Almond_blossom_-_Google_Art_Project.jpg',
      },
    ],
    'Classic': [
      {
        'title': 'The Great Wave',
        'artist': 'Hokusai',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/a/a5/Tsunami_by_hokusai_19th_century.jpg',
      },
      {
        'title': 'The Promenade',
        'artist': 'Monet',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/7/74/Claude_Monet_-_The_Promenade.jpg',
      },
      {
        'title': 'The Kiss',
        'artist': 'Klimt',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/8/84/Gustav_Klimt_016.jpg',
      },
      {
        'title': 'Girl With A Pearl Earring',
        'artist': 'Vermeer',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/d/d7/Meisje_met_de_parel.jpg',
      },
    ],
    'Botanical': [
      {
        'title': 'Water Lilies',
        'artist': 'Claude Monet',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/2/2a/Claude_Monet_-_The_Water_Lilies_-_The_Clouds_-_Google_Art_Project.jpg',
      },
      {
        'title': 'Nympheas',
        'artist': 'Claude Monet',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/9/99/Water-Lilies-and-Japanese-Bridge-%281897-1899%29-Monet.jpg',
      },
      {
        'title': 'The Water Lily Pond',
        'artist': 'Claude Monet',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/5/5f/Claude_Monet_-_The_Water_Lily_Pond_-_Google_Art_Project.jpg',
      },
      {
        'title': 'Irises in Monet Garden',
        'artist': 'Claude Monet',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/0/0d/Claude_Monet_-_Irises_in_Monet%27s_Garden.jpg',
      },
    ],
    'Abstract': [
      {
        'title': 'The Sleeping Gypsy',
        'artist': 'Henri Rousseau',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/9/96/Henri_Rousseau_-_The_Sleeping_Gypsy.jpg',
      },
      {
        'title': 'Night Watch',
        'artist': 'Rembrandt',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/2/28/The_Nightwatch_by_Rembrandt.jpg',
      },
      {
        'title': 'The Swing',
        'artist': 'Fragonard',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/4/4c/Fragonard%2C_Jean-Honor%C3%A9_-_The_Swing.jpg',
      },
      {
        'title': 'Dance at Le Moulin',
        'artist': 'Renoir',
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/8/84/Pierre-Auguste_Renoir%2C_Le_Moulin_de_la_Galette.jpg',
      },
    ],
  };

  @override
  void dispose() {
    _heroController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final username =
        (user?.userMetadata?['username'] ??
                user?.email?.split('@').first ??
                'Collector')
            .toString();
    final avatar = user?.userMetadata?['avatar_url']?.toString();
    final trending = <Map<String, dynamic>>[
      ...homeSeedArtworks.map((e) => e.toMap()),
      ...gallerySeedArtworks.map((e) => e.toMap()),
    ].take(15).toList();
    final categorized = (_categoryCatalog[_selectedCategory] ?? const [])
        .asMap()
        .entries
        .map(
          (e) => {
            'id': '${_selectedCategory}_${e.key}',
            'title': e.value['title']!,
            'artist_name': e.value['artist']!,
            'image_url': e.value['image_url']!,
          },
        )
        .toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 30),
                    Expanded(
                      child: Text(
                        'ARSIVA GALLERY ART',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: const Color(0xFF1657C0),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: avatar != null && avatar.isNotEmpty
                          ? NetworkImage(avatar)
                          : null,
                      child: avatar == null || avatar.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Hey, $username',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const NotificationDetailPage(),
                        ),
                      ),
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFF1657C0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  onSubmitted: (value) {
                    final query = value.trim();
                    if (query.isEmpty) return;
                    setState(() {
                      _history.remove(query);
                      _history.insert(0, query);
                      if (_history.length > 5) _history.removeLast();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Cari karya, artis, atau kategori',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                if (_history.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: _history
                          .map((e) => Chip(label: Text(e)))
                          .toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                SizedBox(
                  height: 340,
                  child: PageView.builder(
                    controller: _heroController,
                    itemCount: homeSeedArtworks.length,
                    onPageChanged: (value) =>
                        setState(() => _heroIndex = value),
                    itemBuilder: (context, index) =>
                        _HeroCard(artwork: homeSeedArtworks[index].toMap()),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    homeSeedArtworks.length,
                    (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _heroIndex == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: _heroIndex == i
                            ? const Color(0xFF2660BC)
                            : const Color(0xFFC9CEDA),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF255FC0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Temukan, simpan, dan kelola karya seni favorit Anda dalam satu galeri digital.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: Text(
                            'Mulai eksplorasi koleksi ARSIVA',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: const Color(0xFF1657C0),
                                  fontWeight: FontWeight.w400,
                                ),
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
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Align(
              alignment: Alignment.center,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _categories
                    .map(
                      (c) => ChoiceChip(
                        label: Text(c),
                        selected: _selectedCategory == c,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = c),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: categorized.length,
            itemBuilder: (_, i) => _CategoryCard(artwork: categorized[i]),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gallery Paling Trending',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  '15 artworks',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childCount: trending.length,
            itemBuilder: (_, i) => _TrendingCard(artwork: trending[i]),
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.artwork});
  final Map<String, dynamic> artwork;

  @override
  Widget build(BuildContext context) {
    final id = artwork['id'].toString();
    final title = artwork['title'].toString();
    final artist = artwork['artist_name'].toString();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ArtworkDetailPage(artwork: artwork),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Stack(
          children: [
            Positioned.fill(
              child: SmartArtImage(
                imageUrl: artwork['image_url'].toString(),
                title: title,
                fit: BoxFit.cover,
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x05000000), Color(0xBF000000)],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: FavoriteHeartButton(artworkId: id),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    artist,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
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
    final id = artwork['id'].toString();
    final title = artwork['title'].toString();
    final artist = artwork['artist_name'].toString();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ArtworkDetailPage(artwork: artwork),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 0.75,
              child: SmartArtImage(
                imageUrl: artwork['image_url'].toString(),
                title: title,
                fit: BoxFit.cover,
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x12000000),
                      Color(0x00000000),
                      Color(0xB2000000),
                    ],
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
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.artwork});

  final Map<String, dynamic> artwork;

  @override
  Widget build(BuildContext context) {
    final id = artwork['id'].toString();
    final title = artwork['title'].toString();
    final artist = artwork['artist_name'].toString();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ArtworkDetailPage(artwork: artwork),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
                  colors: [Color(0x14000000), Color(0x00000000), Color(0xBF000000)],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: FavoriteHeartButton(artworkId: id),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});

  static const _fallbackNotices = [
    ('like', 'Baru saja menyukai karya Anda', '8m'),
    ('comment', 'Mengomentari koleksi Sunflower Anda', '19m'),
    ('follow', 'Mulai mengikuti profil ARSIVA Anda', '31m'),
    ('system', 'Karya terbaru Anda berhasil dipublikasikan', '1h'),
    ('trend', 'Koleksi Anda masuk daftar trending', '2h'),
    ('like', 'Menyimpan The Night Watch ke favorit', '3h'),
    ('comment', 'Memberi komentar pada The Swing', '4h'),
    ('follow', 'Pengguna baru mengikuti profil Anda', '5h'),
    ('system', 'Sinkronisasi koleksi selesai tanpa error', '6h'),
    ('trend', 'Rekomendasi baru tersedia di halaman Home', '8h'),
  ];

  Future<List<(String, String, String)>> _loadNotices() async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return _fallbackNotices;
    try {
      final rows = await client
          .from('notifications')
          .select('title, message, created_at')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(20);
      final notices = rows.map<(String, String, String)>((row) {
        final title = (row['title'] ?? '').toString().toLowerCase();
        final message = (row['message'] ?? '').toString().trim();
        final type = title.contains('like')
            ? 'like'
            : title.contains('comment')
            ? 'comment'
            : title.contains('follow')
            ? 'follow'
            : 'system';
        return (
          type,
          message.isEmpty ? 'Ada aktivitas baru di akun Anda' : message,
          'Baru saja',
        );
      }).toList();
      return notices.isEmpty ? _fallbackNotices : notices;
    } catch (_) {
      return _fallbackNotices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder<List<(String, String, String)>>(
        future: _loadNotices(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notices = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemBuilder: (_, i) {
              final item = notices[i];
              final icon = item.$1 == 'like'
                  ? Icons.favorite_rounded
                  : item.$1 == 'comment'
                  ? Icons.chat_bubble_rounded
                  : item.$1 == 'follow'
                  ? Icons.person_add_alt_rounded
                  : Icons.notifications_active_rounded;
              final color = item.$1 == 'like'
                  ? const Color(0xFFE83E70)
                  : item.$1 == 'comment'
                  ? const Color(0xFF4F67F6)
                  : item.$1 == 'follow'
                  ? const Color(0xFF0B8D6D)
                  : const Color(0xFF6C6C7E);
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: color.withAlpha(38),
                      child: Icon(icon, size: 16, color: color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.$2,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.$3,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, i) => const SizedBox(height: 8),
            itemCount: notices.length,
          );
        },
      ),
    );
  }
}
