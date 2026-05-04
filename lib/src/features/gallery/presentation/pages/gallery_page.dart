import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gallery_detail_pages.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F0F1E) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
            child: Icon(Icons.menu_rounded, color: isDarkMode ? Colors.white : Colors.black, size: 20),
          ),
        ),
        title: Text(
          'ARSIVA',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            letterSpacing: 1.5,
            color: isDarkMode ? Colors.white : const Color(0xFF42275A),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
              child: Icon(Icons.notifications_none_rounded, color: isDarkMode ? Colors.white : Colors.black, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white10 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search artworks...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search_rounded, color: Colors.grey),
                    suffixIcon: const Icon(Icons.tune_rounded, color: Color(0xFF42275A), size: 20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                'Explore Gallery',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            _buildArtCard(context, 'The Starry Night', 'Vincent van Gogh', 'https://picsum.photos/seed/art1/600/400', '4.9', '124 matches'),
            _buildArtCard(context, 'Girl with a Pearl Earring', 'Johannes Vermeer', 'https://picsum.photos/seed/art2/600/400', '4.8', '87 matches'),
            _buildArtCard(context, 'The Persistence of Memory', 'Salvador Dalí', 'https://picsum.photos/seed/art3/600/400', '4.7', '56 matches'),
            _buildArtCard(context, 'Mona Lisa', 'Leonardo da Vinci', 'https://picsum.photos/seed/art4/600/400', '5.0', '210 matches'),
            _buildArtCard(context, 'The Night Watch', 'Rembrandt', 'https://picsum.photos/seed/art5/600/400', '4.6', '42 matches'),
            _buildArtCard(context, 'The Kiss', 'Gustav Klimt', 'https://picsum.photos/seed/art6/600/400', '4.8', '95 matches'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildArtCard(BuildContext context, String title, String artist, String img, String rate, String match) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryDetailPage(
              title: title,
              artist: artist,
              imageUrl: img,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              Image.network(img, height: 220, width: double.infinity, fit: BoxFit.cover),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      artist,
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(rate, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 15),
                        Text(match, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.arrow_outward_rounded, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GalleryDetailPage extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;

  const GalleryDetailPage({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.person_pin_rounded, color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        artist,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      _buildInfoTag(Icons.calendar_today_rounded, 'Period Unknown'),
                      const SizedBox(width: 10),
                      _buildInfoTag(Icons.location_on_rounded, 'Digital Gallery'),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'A magnificent piece of history from the ARSIVA collection. This work brings a new perspective to the museum experience, blending classical beauty with digital immersion.',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF42275A), Color(0xFF734B6D)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF42275A).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'View in AR Experience',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}