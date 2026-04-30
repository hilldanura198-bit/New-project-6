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
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220057FF),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.transparent,
          indicatorColor: Colors.white.withValues(alpha: 0.18),
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
