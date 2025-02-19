import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/views/home/home.dart';

import '../../poviders/bottom_nav_provider.dart';

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    // List of screens corresponding to each tab
    final List<Widget> screens = [
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),

      // WorkoutScreen(),
      // DashboardScreen(),
      // FavoritesScreen(),
      // ChatScreen(),
      // ProfileScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(bottomNavProvider.notifier).state = index,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.purple[300],
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
