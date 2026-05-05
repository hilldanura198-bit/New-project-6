import 'package:flutter/material.dart';

class AuthLandingPage extends StatefulWidget {
  const AuthLandingPage({super.key});

  @override
  State<AuthLandingPage> createState() => _AuthLandingPageState();
}

class _AuthLandingPageState extends State<AuthLandingPage> {
  int _index = 0;

  static const _titles = ['Home', 'Gallery', 'AI', 'Profile'];
  static const _icons = [Icons.home_rounded, Icons.grid_view_rounded, Icons.auto_awesome_rounded, Icons.person_rounded];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index], style: Theme.of(context).textTheme.titleLarge)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Welcome to ARSIVA $_index\nHalaman utama sedang sinkronisasi modul lanjutan.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: List.generate(
          _titles.length,
          (i) => NavigationDestination(icon: Icon(_icons[i]), label: _titles[i]),
        ),
      ),
    );
  }
}
