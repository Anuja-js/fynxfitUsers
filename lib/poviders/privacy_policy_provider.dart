import 'package:flutter_riverpod/flutter_riverpod.dart';

final privacyPolicyProvider = Provider<String>((ref) {
  return '''Welcome to Fynx Fit. Your privacy is important to us, and we are committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our fitness app.

1. Information We Collect
We collect the following types of data when you use our app:

a. Personal Information
- Name, email, phone number, and date of birth (for profile setup)
- Profile image (if uploaded)
- Payment details (processed via Razorpay; we do not store your payment information)

b. Fitness Data
- Workout and activity progress tracking
- Meal plans and preferences
- Subscription details for coaching services

c. Communication Data
- Chat messages
- Video calls and online call logs (we do not store the content of calls)

d. Device & Usage Data
- IP address, device type, and app usage logs
- Crash logs and performance data for app improvements
''';
});