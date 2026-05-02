import 'package:flutter/material.dart';

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
              background: imageUrl.isEmpty
                  ? const ColoredBox(color: Color(0xFFEFE9DE))
                  : Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
