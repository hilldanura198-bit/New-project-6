import 'package:flutter/material.dart';

class PremiumAdjustmentSlider extends StatelessWidget {
  const PremiumAdjustmentSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final normalized = ((value - min) / (max - min)).clamp(0.0, 1.0).toDouble();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleSmall),
              Text(
                value.toStringAsFixed(2),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: normalized),
            duration: const Duration(milliseconds: 180),
            builder: (context, t, child) {
              return SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color.lerp(
                    Theme.of(context).colorScheme.primary,
                    const Color(0xFFC8A96B),
                    t,
                  ),
                  inactiveTrackColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.24),
                  thumbColor: const Color(0xFFC8A96B),
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
