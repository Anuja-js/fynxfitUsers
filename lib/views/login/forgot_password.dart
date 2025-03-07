import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/theme.dart';
import '../../core/utils/constants.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../widgets/customs/custom_text_form_field.dart';
import '../../widgets/customs/custom_elevated_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>(); // Global key for the Form
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: "Enter Your Email",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              sh20,
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomElevatedButton(
                  text: "Reset Password",
                  backgroundColor: AppThemes.darkTheme.primaryColor,
                  onPressed: () async {
                    // Validate the form before submitting
                    if (formKey.currentState!.validate()) {
                      setState(() => isLoading = true);
                      final error = await authViewModel.resetPassword(
                        emailController.text,
                      );
                      setState(() => isLoading = false);

                      if (error == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Reset email sent!")),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                      }
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
