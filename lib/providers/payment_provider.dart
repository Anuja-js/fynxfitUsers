import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

final paymentProvider = ChangeNotifierProvider((ref) => PaymentNotifier());

class PaymentNotifier extends ChangeNotifier {
  Razorpay? _razorpay;

  PaymentNotifier() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void startPayment(String amount, String name, String contact, String email) {
    var options = {
      'key': 'rzp_test_4eiD32ejAydrAE', // Replace with your Razorpay Key
      'amount': int.parse(amount) , // Amount in paisa
      'name': name,
      'description': 'Coach Subscription',
      'prefill': {'contact': contact, 'email': email},
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("Payment Successful: ${response.paymentId}");
    // Handle success (e.g., update DB, navigate)
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet Used: ${response.walletName}");
  }

  @override
  void dispose() {
    _razorpay?.clear();
    super.dispose();
  }
}
