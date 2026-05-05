import 'package:flutter/material.dart';

import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/pages/signup_page.dart';

class GuestExplorePage extends StatelessWidget {
  const GuestExplorePage({super.key});

  static const _previewImages = [
    'https://images.unsplash.com/photo-1579783901586-d88db74b4fe4?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1547891654-e66ed7ebb968?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1578301978018-3005759f48f7?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1578301978069-45244f1f2e43?auto=format&fit=crop&w=900&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jelajahi Karya',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Nikmati koleksi seni ARSIVA sebagai tamu, lalu masuk untuk pengalaman penuh.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: _previewImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: .75,
                  ),
                  itemBuilder: (_, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(_previewImages[i], fit: BoxFit.cover),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x14000000), Color(0x9A000000)],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          child: Text(
                            'Preview ${i + 1}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
                    );
                  },
                  child: Text('Login', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const SignupPage()),
                    );
                  },
                  child: Text('Sign Up', style: Theme.of(context).textTheme.titleMedium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
