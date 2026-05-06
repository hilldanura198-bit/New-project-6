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
    (
      'SUNFLOWER',
      'VAN GOGH',
      'https://images.unsplash.com/photo-1597848212624-e6f5a1a2f43b?auto=format&fit=crop&w=900&q=80',
    ),
    (
      'THE SLEEPING GYPSY',
      'HENRI ROUSSEAU',
      'https://upload.wikimedia.org/wikipedia/commons/9/96/Henri_Rousseau_-_The_Sleeping_Gypsy.jpg',
    ),
    (
      'WATER LILIES',
      'CLAUDE MONET',
      'https://images.unsplash.com/photo-1468327768560-75b778cbb551?auto=format&fit=crop&w=900&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_index];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF14171F)
          : const Color(0xFFEDEEF3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'ARSIVA GALLERY ART',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isDark
                                  ? const Color(0xFF7DA5FF)
                                  : const Color(0xFF1657C0),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        ref.read(themeModeProvider.notifier).toggle(),
                    icon: Icon(
                      Icons.dark_mode_outlined,
                      color: isDark
                          ? const Color(0xFF7DA5FF)
                          : const Color(0xFF1657C0),
                    ),
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
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(34),
                      child: SmartArtImage(
                        imageUrl: s.$3,
                        title: s.$1,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    Text(
                      slide.$1,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slide.$2,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _index == i ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _index == i
                                ? const Color(0xFF2660BC)
                                : (isDark
                                      ? const Color(0xFF495067)
                                      : const Color(0xFFC8CFDD)),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: isDark
                            ? const Color(0xFF1E4EA8)
                            : const Color(0xFF255FC0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Where Art Meets Digital',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFF4F6FC),
                                foregroundColor: const Color(0xFF1F58B9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: () =>
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute<void>(
                                      builder: (_) => const LoginPage(),
                                    ),
                                  ),
                              child: Text(
                                'JELAJAHI SEKARANG',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: const Color(0xFF1F58B9),
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                          ),
                        ],
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
