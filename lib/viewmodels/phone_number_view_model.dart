import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Model to store phone input details
class PhoneNumberState {
  final String countryCode;
  final String countryFlag;
  final String phoneNumber;

  PhoneNumberState({
    required this.countryCode,
    required this.countryFlag,
    required this.phoneNumber,
  });

  /// Copy method for updating state
  PhoneNumberState copyWith({
    String? countryCode,
    String? countryFlag,
    String? phoneNumber,
  }) {
    return PhoneNumberState(
      countryCode: countryCode ?? this.countryCode,
      countryFlag: countryFlag ?? this.countryFlag,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

/// Notifier to manage phone input state
class PhoneNumberNotifier extends StateNotifier<PhoneNumberState> {
  PhoneNumberNotifier()
      : super(PhoneNumberState(
    countryCode: "+1", // Default country code
    countryFlag: "US", // Default flag code (US)
    phoneNumber: "",
  ));

  /// Update selected country code
  void updateCountryCode(String newCode) {
    state = state.copyWith(countryCode: newCode);
  }

  /// Update country flag
  void updateCountryFlag(String newFlag) {
    state = state.copyWith(countryFlag: newFlag.toUpperCase());
  }

  /// Update phone number
  void updatePhoneNumber(String newNumber) {
    state = state.copyWith(phoneNumber: newNumber);
  }
}

/// Provider for Phone Number State
final phoneInputProvider = StateNotifierProvider<PhoneNumberNotifier, PhoneNumberState>((ref) {
  return PhoneNumberNotifier();
});
