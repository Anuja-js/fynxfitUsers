import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/login/login.dart';
import 'package:fynxfituser/views/signup/sign_up.dart';
import 'package:fynxfituser/widgets/customs/custom_elevated_button.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}