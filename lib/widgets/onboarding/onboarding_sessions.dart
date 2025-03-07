import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/login/login.dart';
import 'package:fynxfituser/widgets/customs/custom_elevated_button.dart';

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