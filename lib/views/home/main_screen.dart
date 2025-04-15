import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Message: ${message.notification?.title}");
      // You can show a custom dialog or snackbar here
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from background: ${message.notification?.title}");
      // Navigate to a specific screen, e.g. workout screen
    });
  }
  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
"fcmtocken":token
    }, SetOptions(merge: true));
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void fetchInitialData() {
    ref.read(articleProvider.notifier).fetchArticles();
    ref.read(workoutProvider.notifier).fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavProvider);

    final List<Widget> screens = [
      HomeScreen(),
     BMICalculatorPage(),
     FavoritesScreen(userId: FirebaseAuth.instance.currentUser!.uid),
      MessagedCoachesListScreen(),
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
