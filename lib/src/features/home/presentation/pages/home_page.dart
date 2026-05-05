import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/data/artworks_seed.dart';
import '../../../artwork/presentation/pages/artwork_detail_page.dart';
import '../../../artwork/presentation/widgets/favorite_heart_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';

  List<String> get _categories {
    final set = <String>{'All', ...homeSeedArtworks.map((e) => e.category)};
    return set.toList();
  }

  List<Map<String, dynamic>> get _items {
    final list = homeSeedArtworks
        .where((e) => _selectedCategory == 'All' || e.category == _selectedCategory)
        .map((e) => e.toMap())
        .toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'ARSIVA GALLERY ART',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF111111),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Koleksi Pilihan', style: textTheme.titleLarge),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      final c = _categories[i];
                      final selected = c == _selectedCategory;
                      return ChoiceChip(
                        label: Text(c),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedCategory = c),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemCount: _categories.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childCount: _items.length,
            itemBuilder: (_, i) => _ArtworkCard(artwork: _items[i]),
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
    final title = (artwork['title'] ?? '').toString();
    final imageUrl = (artwork['image_url'] ?? '').toString();
    final price = artwork['price'];
    final id = artwork['id'].toString();

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ArtworkDetailPage(artwork: artwork))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFE4E8F2)),
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x0A000000), Color(0x00000000), Color(0xB0000000)]),
                ),
              ),
            ),
            Positioned(top: 8, right: 8, child: FavoriteHeartButton(artworkId: id)),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('Rp $price', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

