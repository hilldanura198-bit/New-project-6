import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/main_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;

  Stream<List<Map<String, dynamic>>> _artworksStream() {
    return Supabase.instance.client
        .from('artworks')
        .stream(primaryKey: ['id']).order('created_at', ascending: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ARSIVA Collection', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Pilihan karya seni kurasi premium untuk kolektor modern.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _artworksStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Gagal memuat galeri: ${snapshot.error}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    final artworks = snapshot.data ?? const [];
                    if (artworks.isEmpty) {
                      return Center(
                        child: Text(
                          'Belum ada karya di tabel artworks.',
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
                        return ArtworkCard(artwork: artworks[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MainNavigation(
        currentIndex: _navIndex,
        onTap: (index) {
          setState(() {
            _navIndex = index;
          });
        },
      ),
    );
  }
}

class ArtworkCard extends StatefulWidget {
  const ArtworkCard({super.key, required this.artwork});

  final Map<String, dynamic> artwork;

  @override
  State<ArtworkCard> createState() => _ArtworkCardState();
}

class _ArtworkCardState extends State<ArtworkCard> {
  bool _previewMode = true;

  @override
  Widget build(BuildContext context) {
    final title = (widget.artwork['title'] ?? 'Untitled').toString();
    final artist = (widget.artwork['artist_name'] ?? 'Unknown Artist').toString();
    final imageUrl = (widget.artwork['image_url'] ?? '').toString();
    final priceRaw = widget.artwork['price'];
    final priceLabel = priceRaw == null ? 'Price on request' : 'Rp $priceRaw';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: AspectRatio(
                  aspectRatio: _previewMode ? 3 / 4 : 4 / 3,
                  child: imageUrl.isEmpty
                      ? const ColoredBox(color: Color(0xFFEFE9DE))
                      : Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Preview',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                      ),
                      Transform.scale(
                        scale: 0.78,
                        child: Switch(
                          value: _previewMode,
                          activeColor: AppTheme.primaryBlue,
                          onChanged: (value) {
                            setState(() {
                              _previewMode = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(artist, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 10),
                Text(
                  priceLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
