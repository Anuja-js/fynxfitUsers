import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../models/transaction_model.dart';

final transactionProvider = StateNotifierProvider<TransactionNotifier, List<TransactionModel>>((ref) {
  return TransactionNotifier();
});

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionNotifier()
      : super([
    TransactionModel(
        title: "Monthly Subscription",
        amount: -49.99,
        dateTime: DateTime.now().subtract(Duration(days: 1)),
        icon: Icons.subscriptions),
    TransactionModel(
        title: "Personal Training Session",
        amount: -19.99,
        dateTime: DateTime.now().subtract(Duration(days: 3)),
        icon: Icons.fitness_center),
    TransactionModel(
        title: "Diet Consultation",
        amount: -9.99,
        dateTime: DateTime.now().subtract(Duration(days: 5)),
        icon: Icons.restaurant),
  ]);
}
