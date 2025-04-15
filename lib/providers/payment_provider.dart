import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

final paymentProvider = ChangeNotifierProvider((ref) => PaymentNotifier());

class PaymentNotifier extends ChangeNotifier {
  Razorpay? razorpay;

  PaymentNotifier() {
    razorpay = Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  void startPayment(String amount, String name, String contact, String email,) {
    var options = {
      'key': 'rzp_test_4eiD32ejAydrAE', //Razorpay Key
      'amount':(double.parse(amount) * 100).toInt(),

      'name': name,
      'description': 'Coach Subscription',
      'prefill': {'contact': contact, 'email': email},
    };

    try {
      razorpay!.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }


  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint("Payment Successful: ${response.paymentId}");

    // Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String userId = FirebaseAuth.instance.currentUser!.uid;
    DateTime expireDate = DateTime.now().add(Duration(days: 30));

    try {
      await firestore.collection('users').doc(userId).update({
        'subscribe': true,
        'expire_date': expireDate.toIso8601String(),
      });

      debugPrint("User subscription updated in Firestore.");
    } catch (e) {
      debugPrint("Error updating Firestore: $e");
    }
  }
  void handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Failed: ${response.message}");
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet Used: ${response.walletName}");
  }

  @override
  void dispose() {
    razorpay?.clear();
    super.dispose();
  }
}




