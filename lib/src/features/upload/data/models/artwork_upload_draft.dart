class ArtworkUploadDraft {
  const ArtworkUploadDraft({
    required this.title,
    required this.artist,
    required this.year,
    required this.medium,
    required this.description,
    required this.category,
  });

  final String title;
  final String artist;
  final String year;
  final String medium;
  final String description;
  final String category;

  List<String> validate() {
    final errors = <String>[];
    if (title.trim().isEmpty) errors.add('Title is required.');
    if (artist.trim().isEmpty) errors.add('Artist is required.');
    if (year.trim().isEmpty) {
      errors.add('Year is required.');
    } else {
      final parsed = int.tryParse(year.trim());
      if (parsed == null || parsed < 1000 || parsed > 3000) {
        errors.add('Year must be a valid number.');
      }
    }
    if (medium.trim().isEmpty) errors.add('Medium is required.');
    if (description.trim().isEmpty) errors.add('Description is required.');
    if (category.trim().isEmpty) errors.add('Category is required.');
    return errors;
  }
}
