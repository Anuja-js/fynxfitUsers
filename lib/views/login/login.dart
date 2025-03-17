// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/home/main_screen.dart';
import 'package:fynxfituser/views/profile/profileonboading/profile_onboading.dart';
import 'package:fynxfituser/views/login/forgot_password.dart';
import 'package:fynxfituser/views/signup/sign_up.dart';
import 'package:fynxfituser/widgets/customs/custom_images.dart';
import 'package:fynxfituser/widgets/signup/login_widget.dart';
import '../../core/utils/constants.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../widgets/customs/custom_text.dart';
import '../../widgets/customs/custom_text_form_field.dart';
import '../../widgets/customs/custom_elevated_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ref.read(authProvider.notifier);
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomImages(image: "assets/images/welcome.png"),
            sh50,
            CustomText(
              text: "Welcome Back",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            const CustomText(
              text: "Log in to continue",
              color: Color(0xff6D6D6D),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EmailSession(emailController: emailController),
                    sh10,
                    PasswordSession(passwordController: passwordController),
                    const ForgetPassword(),
                    sh10,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CustomElevatedButton(
                        text: "Login",
                        textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                        backgroundColor: AppThemes.darkTheme.primaryColor,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              final auth =
                                  FirebaseAuth.instance.currentUser;
                              if (auth != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MainScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Invalid email or password"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    sh10,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CustomElevatedButton(
                        text: "Login with Google",
                        textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                        backgroundColor: AppThemes.darkTheme.primaryColor,
                        onPressed: () async {
                          try {
                            final auth =
                                await FirebaseAuth.instance.currentUser;
                            if (auth != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ProfileOnboadingOne(userId: auth.uid)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Google Sign-In failed. Try again."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                      ),
                    ),
                    sh10,
                    const SignUpSession(),
                    sh20,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpSession extends StatelessWidget {
  const SignUpSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LoginWidget(
      ontap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUp()),
        );
      },
      richtext2: "signup",
      richtext1: "Don't have an account?",
    );
  }
}

class EmailSession extends StatelessWidget {
  const EmailSession({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      hintText: "Enter Your Email",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }
}

class PasswordSession extends StatelessWidget {
  const PasswordSession({
    super.key,
    required this.passwordController,
  });

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: passwordController,
      keyboardType: TextInputType.text,
      hintText: "Enter Your Password",
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
        child: const Text("Forgot Password?"),
      ),
    );
  }
}
