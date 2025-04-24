// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/bmi/bmi_calculation_page.dart';
import 'package:fynxfituser/views/favorites/favorites.dart';
import '../../providers/article_provider.dart';
import '../../providers/bottom_nav_provider.dart';
import '../../providers/workout_provider.dart';
import '../../viewmodels/profile_view_model.dart';
import '../home/home.dart';
import '../message/message.dart';
import '../profile/profile.page.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    requestPermission();
    fetchInitialData();
    getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final currentIndex = ref.watch(bottomNavProvider);

    final List<Widget> screens = [
      HomeScreen(),
      BMICalculatorPage(),
      FavoritesScreen(userId: FirebaseAuth.instance.currentUser!.uid),
      const MessagedCoachesListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppThemes.darkTheme.scaffoldBackgroundColor
          : AppThemes.lightTheme.scaffoldBackgroundColor,
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
              await ref
                  .read(profileViewModelProvider.notifier)
                  .getUserDetails(auth.uid);
            }
          }
          ref.read(bottomNavProvider.notifier).state = index;
        },
        backgroundColor: isDarkMode
            ? AppThemes.darkTheme.scaffoldBackgroundColor
            : AppThemes.lightTheme.scaffoldBackgroundColor,
        selectedItemColor: AppThemes.darkTheme.primaryColor,
        unselectedItemColor: isDarkMode
            ? AppThemes.lightTheme.scaffoldBackgroundColor
            : AppThemes.darkTheme.scaffoldBackgroundColor,
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

  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"fcmtocken": token}, SetOptions(merge: true));
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else {}
  }

  void fetchInitialData() {
    ref.read(articleProvider.notifier).fetchArticles();
    ref.read(workoutProvider.notifier).fetchWorkouts();
  }
}
