import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodels/profile_view_model.dart';

class ProfileSelectionScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(profileViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile Selection")),
      body: Column(
        children: [
          Text("Tell Us Who You Are"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GenderOption("Female", () => viewModel.updateGender("Female")),
              GenderOption("Male", () => viewModel.updateGender("Male")),
              GenderOption("Other", () => viewModel.updateGender("Other")),
            ],
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

class GenderOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  GenderOption(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
