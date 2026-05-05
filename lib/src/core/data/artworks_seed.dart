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
  SeedArtwork(id: 'h1', title: 'Blue Horizon', artist: 'A. Marlow', category: 'Abstract', imageUrl: 'https://images.unsplash.com/photo-1577083552431-6e5fd01988f1?auto=format&fit=crop&w=1200&q=80', price: 2200000),
  SeedArtwork(id: 'h2', title: 'Silent Garden', artist: 'N. Evra', category: 'Nature', imageUrl: 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?auto=format&fit=crop&w=1200&q=80', price: 1750000),
  SeedArtwork(id: 'h3', title: 'Golden Figure', artist: 'R. Vento', category: 'Portrait', imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=1200&q=80', price: 2650000),
  SeedArtwork(id: 'h4', title: 'City Echoes', artist: 'K. Nadir', category: 'Urban', imageUrl: 'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=1200&q=80', price: 1980000),
  SeedArtwork(id: 'h5', title: 'Light and Dust', artist: 'M. Solis', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1579783901586-d88db74b4fe4?auto=format&fit=crop&w=1200&q=80', price: 2890000),
  SeedArtwork(id: 'h6', title: 'Ivory Motion', artist: 'P. Kenzo', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?auto=format&fit=crop&w=1200&q=80', price: 1500000),
  SeedArtwork(id: 'h7', title: 'Ocean Script', artist: 'L. Aure', category: 'Abstract', imageUrl: 'https://images.unsplash.com/photo-1578301978018-3005759f48f7?auto=format&fit=crop&w=1200&q=80', price: 2060000),
  SeedArtwork(id: 'h8', title: 'Rose Theory', artist: 'S. Damar', category: 'Botanical', imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?auto=format&fit=crop&w=1200&q=80', price: 1920000),
  SeedArtwork(id: 'h9', title: 'Quiet Marble', artist: 'F. Orion', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1577083165633-14ebcdb0f658?auto=format&fit=crop&w=1200&q=80', price: 3010000),
  SeedArtwork(id: 'h10', title: 'Night Current', artist: 'I. Toma', category: 'Contemporary', imageUrl: 'https://images.unsplash.com/photo-1531913764164-f85c52e6e654?auto=format&fit=crop&w=1200&q=80', price: 2390000),
];

const gallerySeedArtworks = <SeedArtwork>[
  SeedArtwork(id: 'g1', title: 'Amber Rain', artist: 'C. Velas', category: 'Abstract', imageUrl: 'https://images.unsplash.com/photo-1579783928621-7a13d66a62f2?auto=format&fit=crop&w=1200&q=80', price: 2100000),
  SeedArtwork(id: 'g2', title: 'Museum Dawn', artist: 'T. Kairo', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1544967082-d9d25d867d66?auto=format&fit=crop&w=1200&q=80', price: 2560000),
  SeedArtwork(id: 'g3', title: 'Floral Pulse', artist: 'D. Azra', category: 'Botanical', imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=1100&q=80', price: 1730000),
  SeedArtwork(id: 'g4', title: 'Stone Memory', artist: 'H. Paulo', category: 'Sculpture', imageUrl: 'https://images.unsplash.com/photo-1536924940846-227afb31e2a5?auto=format&fit=crop&w=1200&q=80', price: 3250000),
  SeedArtwork(id: 'g5', title: 'Sky Geometry', artist: 'B. Ardi', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1578301978069-45244f1f2e43?auto=format&fit=crop&w=1200&q=80', price: 1870000),
  SeedArtwork(id: 'g6', title: 'Curator Notes', artist: 'J. Mille', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=1200&q=80', price: 1620000),
  SeedArtwork(id: 'g7', title: 'Copper Silence', artist: 'Q. Rasa', category: 'Portrait', imageUrl: 'https://images.unsplash.com/photo-1574182245530-967d9b3831af?auto=format&fit=crop&w=1200&q=80', price: 2780000),
  SeedArtwork(id: 'g8', title: 'Echoed Lines', artist: 'E. Sora', category: 'Urban', imageUrl: 'https://images.unsplash.com/photo-1561214115-f2f134cc4912?auto=format&fit=crop&w=1200&q=80', price: 1990000),
  SeedArtwork(id: 'g9', title: 'Ivory Room', artist: 'W. Dean', category: 'Interior', imageUrl: 'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=1000&q=80', price: 2410000),
  SeedArtwork(id: 'g10', title: 'Velvet Bloom', artist: 'Z. Hana', category: 'Contemporary', imageUrl: 'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?auto=format&fit=crop&w=1200&q=80', price: 2330000),
];

