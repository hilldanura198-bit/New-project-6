class SeedArtwork {
  const SeedArtwork({
    required this.id,
    required this.title,
    required this.artist,
    required this.category,
    required this.imageUrl,
    required this.price,
  });

  final String id;
  final String title;
  final String artist;
  final String category;
  final String imageUrl;
  final int price;

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'artist_name': artist,
    'category': category,
    'image_url': imageUrl,
    'price': price,
  };
}

const homeSeedArtworks = <SeedArtwork>[
  SeedArtwork(
    id: 'h1',
    title: 'STARRY NIGHT',
    artist: 'VAN GOGH',
    category: 'Post-Impressionism',
    imageUrl:
        'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1400&q=80',
    price: 2750000,
  ),
  SeedArtwork(
    id: 'h2',
    title: 'SUNFLOWERS',
    artist: 'VAN GOGH',
    category: 'Post-Impressionism',
    imageUrl:
        'https://images.unsplash.com/photo-1470509037663-253afd7f0f51?auto=format&fit=crop&w=1400&q=80',
    price: 2200000,
  ),
  SeedArtwork(
    id: 'h3',
    title: 'ALMOND BLOSSOM',
    artist: 'VAN GOGH',
    category: 'Botanical',
    imageUrl:
        'https://images.unsplash.com/photo-1455659817273-f96807779a8a?auto=format&fit=crop&w=1400&q=80',
    price: 1980000,
  ),
  SeedArtwork(
    id: 'h4',
    title: 'THE KISS',
    artist: 'GUSTAV KLIMT',
    category: 'Symbolism',
    imageUrl:
        'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=1400&q=80',
    price: 2890000,
  ),
  SeedArtwork(
    id: 'h5',
    title: 'THE SOWER',
    artist: 'VAN GOGH',
    category: 'Post-Impressionism',
    imageUrl:
        'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1400&q=80',
    price: 2410000,
  ),
];

const gallerySeedArtworks = <SeedArtwork>[
  SeedArtwork(
    id: 'g1',
    title: 'SUNFLOWER STUDY',
    artist: 'VAN GOGH',
    category: 'Classic',
    imageUrl:
        'https://images.unsplash.com/photo-1470509037663-253afd7f0f51?auto=format&fit=crop&w=1400&q=80',
    price: 2100000,
  ),
  SeedArtwork(
    id: 'g2',
    title: 'THE SLEEPING GYPSY',
    artist: 'HENRI ROUSSEAU',
    category: 'Naive Art',
    imageUrl:
        'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?auto=format&fit=crop&w=1400&q=80',
    price: 2730000,
  ),
  SeedArtwork(
    id: 'g3',
    title: 'THE SWING',
    artist: 'FRAGONARD',
    category: 'Rococo',
    imageUrl:
        'https://images.unsplash.com/photo-1561214115-f2f134cc4912?auto=format&fit=crop&w=1400&q=80',
    price: 2870000,
  ),
  SeedArtwork(
    id: 'g4',
    title: 'THE NIGHT WATCH',
    artist: 'REMBRANDT',
    category: 'Baroque',
    imageUrl:
        'https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=1400&q=80',
    price: 3250000,
  ),
  SeedArtwork(
    id: 'g5',
    title: 'THE HAY WAIN',
    artist: 'JOHN CONSTABLE',
    category: 'Landscape',
    imageUrl:
        'https://images.unsplash.com/photo-1462275646964-a0e3386b89fa?auto=format&fit=crop&w=1400&q=80',
    price: 2780000,
  ),
  SeedArtwork(
    id: 'g6',
    title: 'DANCE AT LE MOULIN DE LA GALETTE',
    artist: 'RENOIR',
    category: 'Impressionism',
    imageUrl:
        'https://images.unsplash.com/photo-1541701494587-cb58502866ab?auto=format&fit=crop&w=1400&q=80',
    price: 2990000,
  ),
  SeedArtwork(
    id: 'g7',
    title: 'THE PROMENADE',
    artist: 'MONET',
    category: 'Impressionism',
    imageUrl:
        'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?auto=format&fit=crop&w=1400&q=80',
    price: 2390000,
  ),
  SeedArtwork(
    id: 'g8',
    title: 'THE GREAT WAVE',
    artist: 'HOKUSAI',
    category: 'Ukiyo-e',
    imageUrl:
        'https://images.unsplash.com/photo-1579783928621-7a13d66a62f2?auto=format&fit=crop&w=1400&q=80',
    price: 2560000,
  ),
];
