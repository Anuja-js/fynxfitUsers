import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/viewmodels/auth_view_model.dart';
import 'package:fynxfituser/widgets/signup/sign_up_selection_button.dart';
import '../../theme.dart';
import '../../widgets/customs/custom_images.dart';
import '../../widgets/customs/custom_text.dart';
import '../../widgets/signup/login_widget.dart';
import '../login/login.dart';

class SignUp extends ConsumerWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authProvider.notifier);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppThemes.darkTheme.scaffoldBackgroundColor
          : AppThemes.lightTheme.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CustomImages(image: "assets/images/signup.png"),
          sh50,
          CustomText(
            text: "Join Us Today!",
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          const CustomText(
            text: "Create Your Account",
            color: Color(0xff6D6D6D),
          ),
          const Spacer(),
          SelectionAuthButton(
            authViewModel: authViewModel,
            ref: ref,
          ),
          LoginWidget(
            ontap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            richtext2: " login",
            richtext1: "Already have an account?",
          ),
          sh20
        ],
      ),
    );
  }
}
