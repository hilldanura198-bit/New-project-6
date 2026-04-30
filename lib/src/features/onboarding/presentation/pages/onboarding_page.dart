import 'package:flutter/material.dart';

import '../../../auth/presentation/pages/login_page.dart';
import '../widgets/hero_artwork_card.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ARSIVA Gallery Art',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      letterSpacing: 0.6,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Rasakan pengalaman menjelajah karya seni pilihan dalam nuansa galeri premium.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 22),
              const HeroArtworkCard(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const LoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Mulai Jelajahi',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
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
