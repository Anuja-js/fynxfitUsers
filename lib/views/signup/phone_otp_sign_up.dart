import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/viewmodels/auth_view_model.dart';
import '../../theme.dart';
import '../../viewmodels/phone_number_view_model.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form_field.dart';


class PhoneOtpSignUp extends ConsumerStatefulWidget {
  const PhoneOtpSignUp({super.key});

  @override
  ConsumerState<PhoneOtpSignUp> createState() => _PhoneOtpSignUpState();
}

class _PhoneOtpSignUpState extends ConsumerState<PhoneOtpSignUp> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final phoneNotifier = ref.read(phoneInputProvider.notifier);
    final phoneState = ref.watch(phoneInputProvider);
    final authNotifier = ref.watch(authProvider.notifier);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up with Phone")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 45.h,
              child: CustomTextFormField(
                controller: _phoneController, // Use controller to capture input
                keyboardType: TextInputType.phone,
                prefixIcon: GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (Country country) {
                        phoneNotifier.updateCountryCode("+${country.phoneCode}");
                        phoneNotifier.updateCountryFlag(country.countryCode);
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
                    width: 80.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppThemes.darkTheme.appBarTheme.foregroundColor
                          : AppThemes.lightTheme.appBarTheme.foregroundColor,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      children: [
                        CountryFlag.fromCountryCode(
                          phoneState.countryFlag.toUpperCase(),
                          borderRadius: 0,
                          height: 18.h,
                          width: 22.w,
                        ),
                        const SizedBox(width: 5),
                        CustomText(
                          text: phoneState.countryCode,
                          color: AppThemes.darkTheme.scaffoldBackgroundColor,
                        ),
                        Icon(Icons.arrow_drop_down,
                            color: AppThemes.darkTheme.scaffoldBackgroundColor),
                      ],
                    ),
                  ),
                ),
                hintText: "Create Account Using PhoneNumber",
                textAlign: TextAlign.end,
                hintColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                onChanged: phoneNotifier.updatePhoneNumber,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final phoneNumber = phoneState.countryCode + _phoneController.text.trim();
                var formattedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
                if (!formattedNumber.startsWith('+')) {
                  formattedNumber = '+$formattedNumber';
                }

                if (formattedNumber.length < 10 || formattedNumber.length > 15) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid phone number format.")),
                  );
                  return;
                }

                authNotifier.sendOtp(formattedNumber, context);
              },
              child: const Text("Get OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
