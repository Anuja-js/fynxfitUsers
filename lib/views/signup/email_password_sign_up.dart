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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _emailController = ref.watch(emailControllerProvider);
    final _passwordController = ref.watch(passwordControllerProvider);
    final _confirmPasswordController = ref.watch(confirmPasswordControllerProvider);

    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    final authViewModel = ref.read(authProvider.notifier);
    final passViewModel = ref.read(passwordVisibilityProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Wrap the fields in a Form widget with the _formKey
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: _emailController,
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
                controller: _confirmPasswordController,
                keyboardType: TextInputType.text,
                hintText: "Confirm Your Password",
                textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }
                  if (value != _passwordController.text) {
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
                  onPressed: () {
                    // Validate all fields in the form.
                    if (_formKey.currentState!.validate()) {
                      authViewModel.signUpWithEmail(
                        _emailController.text,
                        _passwordController.text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext ctx) {
                          return const LoginScreen();
                        }),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
