import 'dart:async';

import 'package:flutter/material.dart';

import 'guest_explore_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const GuestExplorePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A63F2), Color(0xFF7388FF)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ARSIVA',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gallery Art',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withAlpha(220),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
