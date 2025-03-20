
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/profile/profileonboading/picture_selection_page.dart';
import 'package:fynxfituser/views/profile/profileonboading/weight_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'birthday_selection.dart';
import 'fitness_goals_selection_screen.dart';
import 'gender_selection_page.dart';
import 'height_selection_screen.dart';

class ProfileOnboadingOne extends ConsumerWidget {
  final PageController pageController = PageController();
  final String userId;

  ProfileOnboadingOne({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: [
              GenderSelectionScreen(controller: pageController, userId: userId),

              BirthdayScreen(controller: pageController),
              WeightScreen(controller: pageController),
              HeightScreen(controller: pageController),
              FitnessGoalsScreen(controller: pageController),
             ProfileImageScreen(),
            ],
          ),
          Positioned(
            top: 0.h,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: pageController,
                count: 6,
                effect: WormEffect(
                  dotColor: Colors.grey,
                  activeDotColor: Colors.purple,
                  dotWidth: 55.w,
                  dotHeight: 8.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
