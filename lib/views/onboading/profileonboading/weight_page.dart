import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodels/profile_view_model.dart';

class WeightScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(profileViewModelProvider.notifier);
    double weight = 75;

    return Scaffold(
      appBar: AppBar(title: Text("Enter Your Weight")),
      body: Column(
        children: [
          Text("What is your weight?"),
          Slider(
            min: 30,
            max: 150,
            value: weight,
            onChanged: (value) {
              weight = value;
              viewModel.updateWeight(value);
            },
          ),
          Text("$weight Kg"),
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
