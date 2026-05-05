import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../editing/presentation/pages/artwork_editing_page.dart';
import '../widgets/favorite_heart_button.dart';

class ArtworkDetailPage extends StatelessWidget {
  const ArtworkDetailPage({super.key, required this.artwork});

  final Map<String, dynamic> artwork;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final title = (artwork['title'] ?? 'Untitled').toString();
    final artist = (artwork['artist_name'] ?? 'Unknown Artist').toString();
    final imageUrl = (artwork['image_url'] ?? '').toString();
    final description = (artwork['description'] ?? 
        'Full archival documentation for curated art pieces including statues and digital assets.').toString();
    final artworkId = artwork['id'].toString();

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFFDFBF7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            elevation: 0,
            stretch: true,
            backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: isDarkMode ? Colors.black54 : Colors.white70,
                child: BackButton(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: isDarkMode ? Colors.black54 : Colors.white70,
                  child: FavoriteHeartButton(artworkId: artworkId),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'artwork-$artworkId',
                child: imageUrl.isEmpty
                    ? Container(color: const Color(0xFFEFE9DE))
                    : Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.6,
                      color: isDarkMode ? Colors.white60 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isDarkMode ? [] : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(isDarkMode, 'Category', 'Art Archive'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Colors.white10),
                        ),
                        _buildInfoRow(isDarkMode, 'Status', 'Verified'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Colors.white10),
                        ),
                        _buildInfoRow(isDarkMode, 'Location', 'Central Gallery'),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F3DBB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'DOWNLOAD ARCHIVE',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ArtworkEditingPage(artwork: artwork),
                          ),
                        );
                      },
                      icon: Icon(Icons.auto_awesome_motion_rounded, 
                        size: 20, 
                        color: isDarkMode ? Colors.white54 : Colors.black54),
                      label: Text(
                        'Modify Display Settings',
                        style: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.white54 : Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(bool isDark, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white60, 
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
