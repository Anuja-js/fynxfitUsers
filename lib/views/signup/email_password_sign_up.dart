import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/viewmodels/password_vilible_view_model.dart';
import 'package:fynxfituser/views/login/login.dart';

import '../../providers/text_filed_providers.dart';
import '../../theme.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../widgets/customs/custom_elevated_button.dart';
import '../../widgets/customs/custom_text_form_field.dart';

class EmailPasswordSignUp extends ConsumerStatefulWidget {
  const EmailPasswordSignUp({super.key});

  @override
  ConsumerState<EmailPasswordSignUp> createState() => _EmailPasswordSignUpState();
}

class _EmailPasswordSignUpState extends ConsumerState<EmailPasswordSignUp> {
  // Create a GlobalKey to uniquely identify the Form widget and allow validation.
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final confirmPasswordController = ref.watch(confirmPasswordControllerProvider);

    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    final authViewModel = ref.read(authProvider.notifier);
    final passViewModel = ref.read(passwordVisibilityProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Wrap the fields in a Form widget with the formKey
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: "Enter Your Email",
                textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  // Simple email validation pattern
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: passwordController,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: confirmPasswordController,
                keyboardType: TextInputType.text,
                hintText: "Confirm Your Password",
                textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }
                  if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomElevatedButton(
                  backgroundColor: AppThemes.darkTheme.primaryColor,
                  textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                  text: "Create Account",
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      ref.read(isLoadingProvider.notifier).state = true; // Show loader
                      try {
                        await authViewModel.signUpWithEmail(
                          emailController.text,
                          passwordController.text,
                        );

                        emailController.clear();
                        passwordController.clear();
                        confirmPasswordController.clear();

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext ctx) => const LoginScreen()),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      } finally {
                        ref.read(isLoadingProvider.notifier).state = false; // Hide loader
                      }
                    }
                  },

                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.white.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
