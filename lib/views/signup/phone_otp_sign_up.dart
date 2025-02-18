
import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/constants.dart';
import '../../theme.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../viewmodels/phone_number_view_model.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form_field.dart';

class EmailPasswordSignUp extends ConsumerStatefulWidget {
  const EmailPasswordSignUp({super.key});

  @override
  ConsumerState<EmailPasswordSignUp> createState() => _EmailPasswordSignUpState();
}

class _EmailPasswordSignUpState extends ConsumerState<EmailPasswordSignUp> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final phoneState = ref.watch(phoneInputProvider);
    final phoneNotifier = ref.read(phoneInputProvider.notifier);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
  width: MediaQuery.of(context).size.width,
  height: 45.h,
  child: CustomTextFormField(
    keyboardType: TextInputType.phone,
    prefixIcon: GestureDetector(
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: true,
          onSelect: (Country country) {
            phoneNotifier
                .updateCountryCode("+${country.phoneCode}");
            phoneNotifier.updateCountryFlag(
                country.countryCode); // Ensure flag updates
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 5.h, horizontal: 3.w),
        width: MediaQuery.of(context).size.width / 4.2,
        height: 44.h,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppThemes
                  .darkTheme.appBarTheme.foregroundColor
              : AppThemes
                  .lightTheme.appBarTheme.foregroundColor,
          borderRadius: BorderRadius.circular(9),
          // border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [sw5,
            CountryFlag.fromCountryCode(
              phoneState.countryFlag
                  .toUpperCase(), borderRadius: 0,
              height: 18.h,
              width: 22.w,
            ),
            CustomText(
              text: phoneState.countryCode,
              color: AppThemes
                  .darkTheme.scaffoldBackgroundColor,
            ),
            Icon(Icons.arrow_drop_down,
                color: AppThemes
                    .darkTheme.scaffoldBackgroundColor),
          ],
        ),
      ),
    ),
    hintText: "Create Account Using PhoneNumber",textAlign: TextAlign.end,
    hintColor: AppThemes.darkTheme.scaffoldBackgroundColor,
    textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
    onChanged: phoneNotifier.updatePhoneNumber,
  ),
),
          ],
        ),
      ),
    );
  }
}
