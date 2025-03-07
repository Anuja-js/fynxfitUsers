import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/viewmodels/auth_view_model.dart';
import 'package:fynxfituser/views/profile/profileonboading/profile_onboading.dart';
import 'package:fynxfituser/views/signup/email_password_sign_up.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';

import '../../core/utils/constants.dart';

class SelectionAuthButton extends StatelessWidget {
  const SelectionAuthButton(
      {super.key, required this.authViewModel, required this.ref});

  final AuthViewModel authViewModel;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Form(
        child: Column(
          children: [
            SignUpBoxes(
              authViewModel: authViewModel,
              onTap: () async {
                final authState = ref.watch(authProvider);


                await authViewModel.signInWithGoogle();
                final auth=await FirebaseAuth.instance.currentUser;
                if (auth != null) {
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileOnboadingOne(userId:   auth!.uid)),
                  );
                }
              },
              text: 'Create Account Using Google',
              icon: Icons.g_mobiledata,
            ),
            OrContainer(),
            SignUpBoxes(
              authViewModel: authViewModel,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return const EmailPasswordSignUp();
                }));
              },
              text: 'Create Account Using Email',
             icon: Icons.email_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class OrContainer extends StatelessWidget {
  const OrContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      height: 20.h,margin: EdgeInsets.symmetric(vertical: 5.h,horizontal: 0),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border(
          left: BorderSide(color: Colors.grey, width: 2),
          right: BorderSide(color: Colors.grey, width: 2),
         top: BorderSide(color: Colors.grey, width: 2),
         bottom: BorderSide(color: Colors.grey, width: 2),

        ),
      ),
      alignment: Alignment.center,
      child: CustomText(
        text: "or",
        color: AppThemes.darkTheme.appBarTheme.foregroundColor!,
        fontSize: 10.sp,
      ),
    );
  }
}
class SignUpBoxes extends StatelessWidget {
  IconData icon;
  String text;
  GestureTapCallback onTap;
  SignUpBoxes({
    super.key,
    required this.authViewModel,
    required this.icon,
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppThemes.darkTheme.appBarTheme.foregroundColor,
              borderRadius: BorderRadius.all(Radius.circular(8.r))),
          child: Row(
            children: [    CustomText(
              textAlign: TextAlign.end,
              color: AppThemes.darkTheme.scaffoldBackgroundColor,
              fontWeight: FontWeight.normal,
              fontSize: 15,
              text: text,
            ),

              Spacer(),
              Icon(icon,color: AppThemes.darkTheme.scaffoldBackgroundColor,)

            ],
          ),
        ),
      ),
    );
  }
}
