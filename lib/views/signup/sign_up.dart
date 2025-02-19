import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/viewmodels/auth_view_model.dart';
import 'package:fynxfituser/views/onboading/profileonboading/profile_onboading_one.dart';
import 'package:fynxfituser/views/signup/email_password_sign_up.dart';
import 'package:fynxfituser/views/signup/phone_otp_sign_up.dart';

import '../../theme.dart';
import '../../widgets/custom_images.dart';
import '../../widgets/custom_text.dart';
import '../login/login.dart';

class SignUp extends ConsumerWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authProvider.notifier);
    final user = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppThemes.darkTheme.scaffoldBackgroundColor
          : AppThemes.lightTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImages(image: "assets/images/login.png"),
            CustomText(
              text: "Join Us Today!",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: "Create Your Account",
              color: const Color(0xff6D6D6D),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Form(
                child: Column(
                  children: [
                    SignUpBoxes(
                      authViewModel: authViewModel,
                      onTap: () async {
                        await authViewModel.signInWithGoogle();
                        if (ref.read(authProvider) != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileSelectionScreen()),
                          );
                        }
                      },
                      text: 'Create Account Using Google',
                      image: 'assets/images/google.png',
                    ),
                    CustomText(
                      text: "or",
                      color: AppThemes.darkTheme.appBarTheme.foregroundColor!,
                    ),
                    SignUpBoxes(
                      authViewModel: authViewModel,
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx){
                          return PhoneOtpSignUp();
                        }));

                      },
                      text: 'Create Account Using PhoneNumber',
                      image: 'assets/images/phone.png',
                    ),
                    CustomText(
                      text: "or",
                      color: AppThemes.darkTheme.appBarTheme.foregroundColor!,
                    ),
                    SignUpBoxes(
                      authViewModel: authViewModel,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext ctx) {
                          return EmailPasswordSignUp();
                        }));
                      },
                      text: 'Create Account Using Email',
                      image: 'assets/images/email.png',
                    ),
                    CustomText(
                      text: "or",
                      color: AppThemes.darkTheme.appBarTheme.foregroundColor!,
                    ),
                  ],
                ),
              ),
            ),
            LoginWidget(),
          ],
        ),
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                color: AppThemes
                    .darkTheme.appBarTheme.foregroundColor, // Title in white
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
    );
  }
}

class SignUpBoxes extends StatelessWidget {
  String image;
  String text;
  GestureTapCallback onTap;
  SignUpBoxes({
    super.key,
    required this.authViewModel,
    required this.image,
    required this.text,
    required this.onTap,
  });

  final AuthViewModel authViewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppThemes.darkTheme.appBarTheme.foregroundColor,
              borderRadius: BorderRadius.all(Radius.circular(8.r))),
          child: Row(
            children: [
              CustomImages(
                image: image,
                height: 30.h,
                width: 35.h,
                fit: BoxFit.fitHeight,
              ),
              sw20,
              Expanded(
                child: CustomText(
                  textAlign: TextAlign.end,
                  color: AppThemes.darkTheme.scaffoldBackgroundColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  text: text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
