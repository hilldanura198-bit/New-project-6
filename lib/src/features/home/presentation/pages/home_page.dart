import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/artworks_seed.dart';
import '../../../../core/state/theme_mode_provider.dart';
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

    final items = homeSeedArtworks
        .where((e) => e.category == _selectedCategory)
        .map((e) => e.toMap())
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('ARSIVA', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xFF1657C0), fontWeight: FontWeight.w800, letterSpacing: 3)),
                          Text('GALLERY ART', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF1657C0), fontWeight: FontWeight.w700, letterSpacing: 1.5)),
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
                    IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1657C0))),
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
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      final c = _categories[i];
                      return ChoiceChip(
                        label: Text(c),
                        selected: _selectedCategory == c,
                        onSelected: (_) => setState(() => _selectedCategory = c),
                      );
                    },
                    separatorBuilder: (_, i) => const SizedBox(width: 8),
                    itemCount: _categories.length,
                  ),
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
            childCount: items.length,
            itemBuilder: (_, i) => _ArtworkCard(artwork: items[i]),
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
            AspectRatio(aspectRatio: 3 / 4, child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFE4E8F2)))),
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
