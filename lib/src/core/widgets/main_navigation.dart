import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF262019)
            : const Color(0xFF111111),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        child: NavigationBar(
          height: 66,
          backgroundColor: Colors.transparent,
          indicatorColor: AppTheme.accentBlue.withAlpha(55),
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.home_rounded, color: Colors.white),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_rounded, color: Colors.white),
              selectedIcon: Icon(Icons.grid_on_rounded, color: Colors.white),
              label: 'Gallery',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.auto_awesome_rounded, color: Colors.white),
              label: 'AI',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: Colors.white),
              selectedIcon: Icon(Icons.person_rounded, color: Colors.white),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

