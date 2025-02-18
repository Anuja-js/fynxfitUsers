import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodels/profile_view_model.dart';

class BirthdayScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(profileViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Enter Your Birthday")),
      body: Column(
        children: [
          Text("When is your birthday?"),
          ElevatedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                viewModel.updateBirthday(pickedDate);
              }
            },
            child: Text("Select Date"),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to next page
            },
            child: Text("Next"),
          ),
        ],
      ),
    );
  }
}
