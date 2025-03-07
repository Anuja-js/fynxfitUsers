import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/widgets/onboarding/onboarding_button.dart';
import 'package:fynxfituser/widgets/onboarding/onboarding_image_view.dart';
import 'package:fynxfituser/widgets/onboarding/onboarding_page_indicator.dart';
import '../../../viewmodels/onboading_view_model.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController pageController = PageController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startAutoPageSwitch();
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageView(pageController: pageController, ref: ref),
          PageIndicator(pageController: pageController),
          sh20,
          const BaseButton(),
        ],
      ),
    );
  }

  void startAutoPageSwitch() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      var currentIndex = ref.read(onboardingProvider);

      if (currentIndex < 4) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        ref.read(onboardingProvider.notifier).updatePage(currentIndex + 1);
      } else {
        pageController.jumpToPage(0);
        ref.read(onboardingProvider.notifier).updatePage(0);
      }
    });
  }
}
