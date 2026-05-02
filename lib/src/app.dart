import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/state/theme_mode_provider.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';

class ArsivaApp extends ConsumerWidget {
  const ArsivaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arsiva Gallery Art',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const OnboardingPage(),
    );
  }
}
