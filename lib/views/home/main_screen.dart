import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/article_provider.dart';
import '../../providers/bottom_nav_provider.dart';
import '../../providers/workout_provider.dart';
import '../../viewmodels/profile_view_model.dart';
import '../home/home.dart';
import '../message/message.dart';
import '../profile/profile.page.dart';


class MainScreen extends ConsumerStatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }
  void _fetchInitialData() {
    ref.read(articleProvider.notifier).fetchArticles();
    ref.read(workoutProvider.notifier).fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      const HomeScreen(),
      const HomeScreen(),
      MessagedUsersListScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) async {
          if (index == 0) {
            ref.read(articleProvider.notifier).fetchArticles();
            ref.read(workoutProvider.notifier).fetchWorkouts();
          }
          if (index == 4) {
            final auth = FirebaseAuth.instance.currentUser;
            if (auth != null) {
              await ref.read(profileViewModelProvider.notifier).getUserDetails(auth.uid);
            }
          }
          ref.read(bottomNavProvider.notifier).state = index;
        },
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
