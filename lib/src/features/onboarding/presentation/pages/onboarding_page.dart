import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/state/theme_mode_provider.dart';
import '../../../../core/widgets/smart_art_image.dart';
import '../../../auth/presentation/pages/login_page.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _slides = [
    ('SUNFLOWER', 'VAN GOGH', 'https://images.unsplash.com/photo-1577083552431-6e5fd01988f1?auto=format&fit=crop&w=1200&q=80'),
    ('VELVET FLORA', 'E. HARLOW', 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?auto=format&fit=crop&w=1200&q=80'),
    ('QUIET LINE', 'N. AZUR', 'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?auto=format&fit=crop&w=1200&q=80'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Column(
                    children: [
                      Text('ARSIVA GALLERY ART', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFF1657C0), fontWeight: FontWeight.w800, letterSpacing: 1.6)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
                    icon: const Icon(Icons.dark_mode_outlined, color: Color(0xFF1657C0)),
                    tooltip: 'Toggle Theme',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (v) => setState(() => _index = v),
                  itemBuilder: (_, i) {
                    final s = _slides[i];
                    return Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: SmartArtImage(
                              imageUrl: s.$3,
                              title: s.$1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(s.$1, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800)),
                        Text(s.$2, style: Theme.of(context).textTheme.titleMedium),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) => AnimatedContainer(duration: const Duration(milliseconds: 220), margin: const EdgeInsets.symmetric(horizontal: 4), width: _index == i ? 22 : 8, height: 8, decoration: BoxDecoration(color: _index == i ? const Color(0xFF1657C0) : const Color(0xFFD8DAE0), borderRadius: BorderRadius.circular(20)))),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                decoration: BoxDecoration(color: const Color(0xFF1657C0), borderRadius: BorderRadius.circular(24)),
                child: Column(
                  children: [
                    Text('Where Art Meets Digital', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const LoginPage())),
                        child: Text('JELAJAHI SEKARANG', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFF1657C0), fontWeight: FontWeight.w800)),
                      ),
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
