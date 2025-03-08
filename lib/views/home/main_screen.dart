import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/views/home/home.dart';
import 'package:fynxfituser/views/message/message.dart';
import 'package:fynxfituser/views/profile/profile.page.dart';

import '../../poviders/bottom_nav_provider.dart';
import '../../viewmodels/profile_view_model.dart';

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        onTap: (index)async {


          if(index==4){

            final auth=await FirebaseAuth.instance.currentUser;
           await ref.read(profileViewModelProvider.notifier).getUserDetails(auth!.uid);

          }  ref.read(bottomNavProvider.notifier).state = index;

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
