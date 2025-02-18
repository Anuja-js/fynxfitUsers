import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/login/login.dart';
import 'package:fynxfituser/views/onboading/normal_onboarding/onboading_screeen.dart';
import 'package:fynxfituser/widgets/custom_splash_icon.dart';
import '../../viewmodels/splash_view_model.dart';

class SplashScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    ref.listen(splashProvider, (previous, isFinished) {
      if (isFinished) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
    });

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppThemes.darkTheme.scaffoldBackgroundColor
          : AppThemes.lightTheme.scaffoldBackgroundColor,
      body: Center(child: IconSplashImage()),
    );
  }
}
