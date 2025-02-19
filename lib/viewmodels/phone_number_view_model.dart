import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneNumberState {
  final String countryCode;
  final String countryFlag;
  final String phoneNumber;

  PhoneNumberState({required this.countryCode, required this.countryFlag, required this.phoneNumber});
}

class PhoneNumberNotifier extends StateNotifier<PhoneNumberState> {
  PhoneNumberNotifier()
      : super(PhoneNumberState(countryCode: "+1", countryFlag: "US", phoneNumber: ""));

  void updateCountryCode(String newCode) => state = PhoneNumberState(countryCode: newCode, countryFlag: state.countryFlag, phoneNumber: state.phoneNumber);
  void updateCountryFlag(String newFlag) => state = PhoneNumberState(countryCode: state.countryCode, countryFlag: newFlag, phoneNumber: state.phoneNumber);
  void updatePhoneNumber(String newNumber) => state = PhoneNumberState(countryCode: state.countryCode, countryFlag: state.countryFlag, phoneNumber: newNumber);
}

final phoneInputProvider = StateNotifierProvider<PhoneNumberNotifier, PhoneNumberState>((ref) {
  return PhoneNumberNotifier();
});
