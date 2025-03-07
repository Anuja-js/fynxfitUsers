import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: pageController,
      count: 5,
      effect: ExpandingDotsEffect(
        activeDotColor: AppThemes.darkTheme.primaryColor,
        dotColor: AppThemes.darkTheme.appBarTheme.foregroundColor!,
        dotHeight: 8.h,
        dotWidth: 8.w,
        expansionFactor: 3,
      ),
    );
  }
}