import 'package:flutter/material.dart';

import '../../../auth/presentation/pages/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _slides = [
    (
      title: 'Jelajahi Karya Kelas Dunia',
      subtitle: 'Temukan koleksi seni digital terbaik dengan pengalaman mobile premium.',
      image: 'https://images.unsplash.com/photo-1577083552431-6e5fd01988f1?auto=format&fit=crop&w=1400&q=80',
    ),
    (
      title: 'Simpan Favorit Anda',
      subtitle: 'Tandai karya favorit dan bangun galeri pribadi Anda di ARSIVA.',
      image: 'https://images.unsplash.com/photo-1579783901586-d88db74b4fe4?auto=format&fit=crop&w=1400&q=80',
    ),
    (
      title: 'Scan dan Edit dengan Mudah',
      subtitle: 'Gunakan scanner dan editor untuk pengalaman seni yang lebih interaktif.',
      image: 'https://images.unsplash.com/photo-1578301978069-45244f1f2e43?auto=format&fit=crop&w=1400&q=80',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Column(
            children: [
              Text(
                'ARSIVA GALLERY ART',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark ? Colors.white : const Color(0xFF111111),
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (context, i) {
                    final slide = _slides[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(color: Color(0x26000000), blurRadius: 16, offset: Offset(0, 8)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              slide.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFDFE5F5)),
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0x14000000), Color(0xB3000000)],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 18,
                              right: 18,
                              bottom: 22,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    slide.title,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    slide.subtitle,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.white.withAlpha(230),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (dot) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _index == dot ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: _index == dot ? const Color(0xFF111111) : const Color(0x66111111),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
                    );
                  },
                  child: Text(
                    'JELAJAHI SEKARANG',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

