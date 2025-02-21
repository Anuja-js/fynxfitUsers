import 'package:flutter/material.dart';

class TransactionModel {
  final String title;
  final double amount;
  final DateTime dateTime;
  final IconData icon;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.dateTime,
    required this.icon,
  });
}
