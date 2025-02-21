import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import '../../../poviders/privacy_policy_provider.dart';
import '../../../widgets/custom_text.dart';
class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyPolicyText = ref.watch(privacyPolicyProvider);

    return Scaffold(   backgroundColor:AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomText(text:'Privacy Policy',fontSize: 18.sp,),elevation: 0,
        backgroundColor:AppThemes.darkTheme.scaffoldBackgroundColor
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: CustomText(text:
            privacyPolicyText,overflow: TextOverflow.visible,
           fontSize: 16),

        ),
      ),
    );
  }
}
