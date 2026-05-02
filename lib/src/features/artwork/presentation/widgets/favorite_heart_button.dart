import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../favorites/presentation/providers/favorites_provider.dart';

class FavoriteHeartButton extends ConsumerStatefulWidget {
  const FavoriteHeartButton({
    super.key,
    required this.artworkId,
    this.size = 20,
    this.onChanged,
  });

  final String artworkId;
  final double size;
  final VoidCallback? onChanged;

  @override
  ConsumerState<FavoriteHeartButton> createState() => _FavoriteHeartButtonState();
}

class _FavoriteHeartButtonState extends ConsumerState<FavoriteHeartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      lowerBound: 0.9,
      upperBound: 1.16,
      value: 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    await _controller.forward();
    await _controller.reverse();
    await ref.read(favoritesProvider.notifier).toggleFavorite(widget.artworkId);
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favoritesProvider);
    final isFavorite = state.ids.contains(widget.artworkId);
    final isPending = state.pendingIds.contains(widget.artworkId);

    return ScaleTransition(
      scale: _controller,
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Colors.black.withValues(alpha: 0.45),
        ),
        onPressed: isPending ? null : _toggle,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey<bool>(isFavorite),
            color: isFavorite ? const Color(0xFFC8A96B) : Colors.white,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}
