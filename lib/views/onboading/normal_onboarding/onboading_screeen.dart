import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/signup/sign_up.dart';
import 'package:fynxfituser/widgets/custom_elevated_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../viewmodels/onboading_view_model.dart';
import '../../login/login.dart';

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
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                ref.read(onboardingProvider.notifier).updatePage(index);
              },
              children: const [
                OnboardingPage(
                    image: "assets/images/im1.png",
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
                    image: "assets/images/im3.png",
                    title: "Your Fitness,",
                    title2: " Your Way",
                    subtitle:
                        "Get customized workout and nutrition plans tailored to your body and goals."),
                OnboardingPage(
                    image: "assets/images/im4.png",
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
          ),
          SmoothPageIndicator(
            controller: pageController,
            count: 5,
            effect: ExpandingDotsEffect(
              activeDotColor: AppThemes.darkTheme.primaryColor,
              dotColor: AppThemes.darkTheme.appBarTheme.foregroundColor!,
              dotHeight: 8.h,
              dotWidth: 8.w,
              expansionFactor: 3,
            ),
          ),
          sh20,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomElevatedButton(
                      backgroundColor: AppThemes.darkTheme.primaryColor,
                      textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                      text: "Create Account",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                        );
                      }),
                ),
                sh10,
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: " Already Have an Account?",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppThemes.darkTheme.appBarTheme
                                .foregroundColor, // Title in white
                          ),
                        ),
                        TextSpan(
                          text: " Login",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppThemes.darkTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String title2;
  final String subtitle;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.title2,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Image.asset(
              image,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 1.3,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
                right: 10.w,
                top: 27.h,
                child: CustomElevatedButton(
                    borderRadius: 10.r,
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    backgroundColor: AppThemes.darkTheme.cardColor,
                    fontSize: 12.sp,
                    text: "Skip",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    })),
            Positioned(
              left: 10.w,
              bottom: 40.h,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.darkTheme.appBarTheme
                            .foregroundColor, // Title in white
                      ),
                    ),
                    TextSpan(
                      text: title2,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.darkTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                left: 10.w,
                bottom: 10.h,
                right: 10.w,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                      color: AppThemes.darkTheme.appBarTheme.foregroundColor,
                    ),
                    maxLines: 2,
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
