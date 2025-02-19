
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/views/onboading/profileonboading/profile_onboading_one.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProfileOnboadingOne extends ConsumerWidget {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: [
              // ProfileSelectionScreen(controller: pageController),
              // BirthdayScreen(controller: pageController),
              // WeightScreen(controller: pageController),
              // HeightScreen(controller: pageController),
              // FitnessGoalScreen(controller: pageController),
              // ProfilePictureScreen(controller: pageController),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: pageController,
                count: 6,
                effect: WormEffect(
                  dotColor: Colors.grey,
                  activeDotColor: Colors.purple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
