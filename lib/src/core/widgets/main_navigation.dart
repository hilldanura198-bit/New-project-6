import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        child: NavigationBar(
          height: 62,
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0x334A63F2),
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined, color: Colors.white), selectedIcon: Icon(Icons.home_rounded, color: Colors.white), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.grid_view_rounded, color: Colors.white), selectedIcon: Icon(Icons.grid_on_rounded, color: Colors.white), label: 'Gallery'),
            NavigationDestination(icon: Icon(Icons.auto_awesome_outlined, color: Colors.white), selectedIcon: Icon(Icons.auto_awesome_rounded, color: Colors.white), label: 'AI'),
            NavigationDestination(icon: Icon(Icons.person_outline_rounded, color: Colors.white), selectedIcon: Icon(Icons.person_rounded, color: Colors.white), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
