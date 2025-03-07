import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/viewmodels/onboading_view_model.dart';
import 'package:fynxfituser/widgets/onboarding/onboarding_sessions.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    required this.pageController,
    required this.ref,
  });

  final PageController pageController;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: pageController,
        onPageChanged: (index) {
          ref.read(onboardingProvider.notifier).updatePage(index);
        },
        children: const [
          OnboardingPage(
              image: "assets/images/im1.jpg",
              title: "Achieve Your",
              title2: " Fitness Goals",
              subtitle:
              "Join a community of fitness enthusiasts, track your progress, and stay motivated every day."),
          OnboardingPage(
              image: "assets/images/im2.png",
              title: "Track &",
              title2: " Improve",
              subtitle:
              "Monitor your workouts, set goals, and see your progress with smart insights and analytics."),
          OnboardingPage(
              image: "assets/images/img3.jpeg",
              title: "Your Fitness,",
              title2: " Your Way",
              subtitle:
              "Get customized workout and nutrition plans tailored to your body and goals."),
          OnboardingPage(
              image: "assets/images/img4.jpg",
              title: "Elevate Your",
              title2: " Fitness",
              subtitle:
              "Tailor your journey, stay focused, overcome challenges, embrace growth, and achieve your goals with confidence."),
          OnboardingPage(
              image: "assets/images/im5.png",
              title: "Let's Get",
              title2: " Started",
              subtitle:
              "Join us today and take the first step towards a healthier, stronger you!"),
        ],
      ),
    );
  }
}

