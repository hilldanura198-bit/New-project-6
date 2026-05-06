class SeedArtwork {
  const SeedArtwork({required this.id, required this.title, required this.artist, required this.category, required this.imageUrl, required this.price});
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
  SeedArtwork(id: 'h1', title: 'SUNFLOWER', artist: 'VAN GOGH', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1577083552431-6e5fd01988f1?auto=format&fit=crop&w=1200&q=80', price: 2200000),
  SeedArtwork(id: 'h2', title: 'VELVET FLORA', artist: 'E. HARLOW', category: 'Botanical', imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?auto=format&fit=crop&w=1200&q=80', price: 1750000),
  SeedArtwork(id: 'h3', title: 'QUIET LINE', artist: 'N. AZUR', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?auto=format&fit=crop&w=1200&q=80', price: 2650000),
  SeedArtwork(id: 'h4', title: 'CLASSIC HALL', artist: 'R. LONDON', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1544967082-d9d25d867d66?auto=format&fit=crop&w=1200&q=80', price: 1980000),
  SeedArtwork(id: 'h5', title: 'BLUE MOTION', artist: 'M. SOLIS', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1579783901586-d88db74b4fe4?auto=format&fit=crop&w=1200&q=80', price: 2890000),
];

const gallerySeedArtworks = <SeedArtwork>[
  SeedArtwork(id: 'g1', title: 'AMBER RAIN', artist: 'C. VELAS', category: 'Abstract', imageUrl: 'https://images.unsplash.com/photo-1579783928621-7a13d66a62f2?auto=format&fit=crop&w=1200&q=80', price: 2100000),
  SeedArtwork(id: 'g2', title: 'MUSEUM DAWN', artist: 'T. KAIRO', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=1200&q=80', price: 2560000),
  SeedArtwork(id: 'g3', title: 'FLORAL PULSE', artist: 'D. AZRA', category: 'Botanical', imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=1100&q=80', price: 1730000),
  SeedArtwork(id: 'g4', title: 'STONE MEMORY', artist: 'H. PAULO', category: 'Sculpture', imageUrl: 'https://images.unsplash.com/photo-1536924940846-227afb31e2a5?auto=format&fit=crop&w=1200&q=80', price: 3250000),
  SeedArtwork(id: 'g5', title: 'SKY GEOMETRY', artist: 'B. ARDI', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1578301978069-45244f1f2e43?auto=format&fit=crop&w=1200&q=80', price: 1870000),
  SeedArtwork(id: 'g6', title: 'COPPER SILENCE', artist: 'Q. RASA', category: 'Portrait', imageUrl: 'https://images.unsplash.com/photo-1574182245530-967d9b3831af?auto=format&fit=crop&w=1200&q=80', price: 2780000),
  SeedArtwork(id: 'g7', title: 'ECHOED LINES', artist: 'E. SORA', category: 'Urban', imageUrl: 'https://images.unsplash.com/photo-1561214115-f2f134cc4912?auto=format&fit=crop&w=1200&q=80', price: 1990000),
  SeedArtwork(id: 'g8', title: 'IVORY ROOM', artist: 'W. DEAN', category: 'Interior', imageUrl: 'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=1000&q=80', price: 2410000),
  SeedArtwork(id: 'g9', title: 'VELVET BLOOM', artist: 'Z. HANA', category: 'Contemporary', imageUrl: 'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?auto=format&fit=crop&w=1200&q=80', price: 2330000),
  SeedArtwork(id: 'g10', title: 'NIGHT STUDY', artist: 'I. TOMA', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1531913764164-f85c52e6e654?auto=format&fit=crop&w=1200&q=80', price: 2390000),
];
