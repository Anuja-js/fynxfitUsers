import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/viewmodels/password_vilible_view_model.dart';
import 'package:fynxfituser/views/login/login.dart';

import '../../poviders/text_filed_providers.dart';
import '../../theme.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';



class EmailPasswordSignUp extends ConsumerWidget {
  const EmailPasswordSignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _emailController = ref.watch(emailControllerProvider);
    final _passwordController = ref.watch(passwordControllerProvider);
    final _confirmPasswordController = ref.watch(confirmPasswordControllerProvider);

    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    final authViewModel = ref.read(authViewModelProvider.notifier);
    final passViewModel = ref.read(passwordVisibilityProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: "Enter Your Email",
              textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              hintText: "Enter Your Password",
              textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
              obscureText: !isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => passViewModel.togglePasswordVisibility(),
              ),
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: _confirmPasswordController,
              keyboardType: TextInputType.text,
              hintText: "Confirm Your Password",
              textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
              obscureText: true,
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                backgroundColor: AppThemes.darkTheme.primaryColor,
                textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                text: "Create Account",
                onPressed: () {
                  if (_passwordController.text == _confirmPasswordController.text) {
                    authViewModel.signInWithEmail(
                      _emailController.text,
                      _passwordController.text,
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx){
                      return LoginScreen();
                    }));
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Passwords do not match")),
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
