import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/home/home.dart';
import 'package:fynxfituser/views/login/forgot_password.dart';
import '../../core/utils/constants.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_elevated_button.dart';
import '../profile/profileonboading/profile_onboading.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(title:  CustomText(text: "Login",fontSize: 15.sp,),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: "Enter Your Email",
            ),
            sh10,
            CustomTextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              hintText: "Enter Your Password",
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen())),
                child: const Text("Forgot Password?"),
              ),
            ),
           Spacer(),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CustomElevatedButton(
                      text: "Login",textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                      backgroundColor: AppThemes.darkTheme.primaryColor,
                      onPressed: () async {
                        setState(() => isLoading = true);
                        final error = await authViewModel.signInWithEmail(
                          _emailController.text,
                          _passwordController.text,
                        );
                        setState(() => isLoading = false);

                        if (error == null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => ProfileOnboadingOne(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        }
                      },
                    ),
                  ),
           sh10,
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                text: "Login with Google",textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                backgroundColor: AppThemes.darkTheme.primaryColor,
                onPressed: () async {
                  final error = await authViewModel.signInWithGoogle();
Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx){
  return HomeScreen();
}));
                  if (error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error)),
                    );
                  }
                },
              ),
            ),
            sh10,
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                text: "Login with PhoneNumber",textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                backgroundColor: AppThemes.darkTheme.primaryColor,
                onPressed: () async {
                  final error = await authViewModel.signInWithGoogle();
                  if (error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error)),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
