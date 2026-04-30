import 'package:flutter/material.dart';

class HeroArtworkCard extends StatelessWidget {
  const HeroArtworkCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=1200&q=80',
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
            const Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: _ArtworkCaption(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtworkCaption extends StatelessWidget {
  const _ArtworkCaption();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Curated Masterpieces\nfor Modern Collectors',
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
    );
  }
}
