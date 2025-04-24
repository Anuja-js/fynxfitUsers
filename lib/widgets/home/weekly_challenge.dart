import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';

class WeeklyChallenges extends StatelessWidget {
  const WeeklyChallenges({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width.w,
      margin:  EdgeInsets.only(right: 12.w, top: 12.h, left: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppThemes.darkTheme.dividerColor.withOpacity(0.25),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Weekly Challenge',
                    fontSize: 18.sp,
                    color: AppThemes.darkTheme.primaryColor,
                  ),
                  CustomText(
                    text: "Plank With Hip Twist",
                    fontSize: 12.sp,
                    color: AppThemes.darkTheme.dividerColor,
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            "assets/images/im1.png",
            width: 100.w,
            height: 110.h,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}