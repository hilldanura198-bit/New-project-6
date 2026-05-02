import 'package:flutter/material.dart';

import '../../../editing/presentation/pages/artwork_editing_page.dart';
import '../widgets/favorite_heart_button.dart';

class ArtworkDetailPage extends StatelessWidget {
  const ArtworkDetailPage({super.key, required this.artwork});

  final Map<String, dynamic> artwork;

  @override
  Widget build(BuildContext context) {
    final title = (artwork['title'] ?? 'Untitled').toString();
    final artist = (artwork['artist_name'] ?? 'Unknown Artist').toString();
    final imageUrl = (artwork['image_url'] ?? '').toString();
    final description = (artwork['description'] ?? 'A timeless artwork in the Arsiva collection.').toString();
    final artworkId = artwork['id'].toString();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FavoriteHeartButton(artworkId: artworkId),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  imageUrl.isEmpty
                      ? const ColoredBox(color: Color(0xFFEFE9DE))
                      : Image.network(imageUrl, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x14000000),
                          Color(0x29000000),
                          Color(0x88000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.45),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(artist, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 20),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder<void>(
                              transitionDuration: const Duration(milliseconds: 280),
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return FadeTransition(
                                  opacity: CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  ),
                                  child: ArtworkEditingPage(artwork: artwork),
                                );
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.tune_rounded),
                        label: const Text('Edit Artwork'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
