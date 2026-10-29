import 'package:disneyapp/screens/dashboard/dashboard_screen.dart';
import 'package:disneyapp/screens/favorites/favorites_screen.dart';
import 'package:disneyapp/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/screens/showtimes/showtimes_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.hourglass_empty_rounded),
      activeIcon: Icon(Icons.hourglass_bottom_rounded),
      label: 'Wait Times',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.theater_comedy_outlined),
      activeIcon: Icon(Icons.theater_comedy),
      label: 'Showtimes',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite_border),
      activeIcon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DashboardScreen(),
          ShowtimeScreen(),
          FavoritesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
