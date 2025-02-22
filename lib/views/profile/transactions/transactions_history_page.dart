import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/constants.dart';
import '../../../poviders/transaction_provider.dart';
import '../../../widgets/custom_text.dart';

class TransactionHistoryPage extends ConsumerWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);

    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: "Transaction History",
          fontSize: 18.sp,
        ),
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                transaction.icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            title: Text(
              transaction.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              DateFormat("dd MMM yyyy, hh:mm a").format(transaction.dateTime),
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "-\$${transaction.amount.abs().toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                sw10,
                Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          );
        },
      ),
    );
  }
}
