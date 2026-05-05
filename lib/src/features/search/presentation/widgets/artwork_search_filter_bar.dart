import 'package:flutter/material.dart';

class ArtworkSearchFilterBar extends StatelessWidget {
  const ArtworkSearchFilterBar({
    super.key,
    required this.controller,
    required this.onQueryChanged,
    required this.categories,
    required this.artists,
    required this.selectedCategory,
    required this.selectedArtist,
    required this.onCategoryChanged,
    required this.onArtistChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onQueryChanged;
  final List<String> categories;
  final List<String> artists;
  final String? selectedCategory;
  final String? selectedArtist;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onArtistChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          // Diakali pakai withAlpha: 0.45 * 255 = 115
          color: Theme.of(context).dividerColor.withAlpha(115),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: onQueryChanged,
            decoration: InputDecoration(
              hintText: 'Search title, artist, category',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        controller.clear();
                        onQueryChanged('');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _dropdown(
                        context: context,
                        label: 'Category',
                        value: selectedCategory,
                        items: categories,
                        onChanged: onCategoryChanged,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _dropdown(
                        context: context,
                        label: 'Artist',
                        value: selectedArtist,
                        items: artists,
                        onChanged: onArtistChanged,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onClear,
                    icon: const Icon(Icons.filter_alt_off_rounded, size: 16),
                    label: const Text('Reset'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required BuildContext context,
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          // Diakali pakai withAlpha: 0.35 * 255 = 89
          color: Theme.of(context).dividerColor.withAlpha(89),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          isExpanded: true,
          hint: Text(label),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text('All $label'),
            ),
            ...items.map(
              (item) => DropdownMenuItem<String?>(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
