import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/views/login/forgot_password.dart';
import 'package:fynxfituser/views/onboading/profileonboading/profile_onboading_one.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_elevated_button.dart';

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
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: "Enter Your Email",
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              hintText: "Enter Your Password",
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                child: const Text("Forgot Password?"),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                text: "Login",
                backgroundColor: Colors.blue,
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
                        builder: (ctx) => ProfileSelectionScreen(),
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
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                text: "Login with Google",
                backgroundColor: Colors.red,
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                text: "Logout",
                backgroundColor: Colors.red,
                onPressed: () async {
                  await authViewModel.signOut();
                  // if (error != null) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text(error)),
                  //   );
                  // }
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                text: "Login with PhoneNumber",
                backgroundColor: Colors.red,
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
