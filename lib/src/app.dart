import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';

class ArsivaApp extends StatelessWidget {
  const ArsivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arsiva Gallery Art',
      theme: AppTheme.light(),
      home: const OnboardingPage(),
    );
  }
}
