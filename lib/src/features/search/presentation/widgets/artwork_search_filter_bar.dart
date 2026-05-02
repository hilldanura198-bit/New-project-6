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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.45),
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
          const SizedBox(height: 10),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _dropdown(
                  context: context,
                  label: 'Category',
                  value: selectedCategory,
                  items: categories,
                  onChanged: onCategoryChanged,
                ),
                _dropdown(
                  context: context,
                  label: 'Artist',
                  value: selectedArtist,
                  items: artists,
                  onChanged: onArtistChanged,
                ),
                OutlinedButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  label: const Text('Reset'),
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
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
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
