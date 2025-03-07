import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/home/main_screen.dart';
import 'package:fynxfituser/views/onboading/normal_onboarding/onboading_screeen.dart';
import 'package:fynxfituser/widgets/customs/custom_splash_icon.dart';
import '../../viewmodels/splash_view_model.dart';
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    ref.listen(splashProvider, (previous, isFinished) async {
      if (isFinished) {
        var user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      }
    });
    return Scaffold(
      backgroundColor: isDarkMode
          ? AppThemes.darkTheme.scaffoldBackgroundColor
          : AppThemes.lightTheme.scaffoldBackgroundColor,
      body: const Center(child: IconSplashImage()),
    );
  }
}
