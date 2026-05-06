import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/widgets/smart_art_image.dart';
import '../../../artwork/presentation/pages/artwork_detail_page.dart';
import '../../../artwork/presentation/widgets/favorite_heart_button.dart';
import '../providers/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final favoritesArtworksAsync = ref.watch(favoriteArtworksProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saved Collection',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Curated works you marked for later appreciation.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (favoritesState.error != null) ...[
                const SizedBox(height: 10),
                Text(
                  favoritesState.error!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.redAccent),
                ),
              ],
              const SizedBox(height: 18),
              Expanded(
                child: favoritesArtworksAsync.when(
                  data: (artworks) {
                    if (artworks.isEmpty) {
                      return Center(
                        child: Text(
                          'No favorites yet. Tap hearts on artworks to build your private collection.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }

                    return MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      itemCount: artworks.length,
                      itemBuilder: (context, index) {
                        final artwork = artworks[index];
                        final artworkId = artwork['id'].toString();
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    ArtworkDetailPage(artwork: artwork),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: SmartArtImage(
                                    imageUrl: (artwork['image_url'] ?? '')
                                        .toString(),
                                    title: (artwork['title'] ?? 'Untitled')
                                        .toString(),
                                  ),
                                ),
                                const Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0x10000000),
                                          Color(0x00000000),
                                          Color(0x96000000),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  right: 44,
                                  bottom: 10,
                                  child: Text(
                                    (artwork['title'] ?? 'Untitled').toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFFF6E8CB),
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: FavoriteHeartButton(
                                    artworkId: artworkId,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (error, _) => Center(
                    child: Text(
                      'Failed to load favorites: $error',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
