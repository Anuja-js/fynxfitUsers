import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/models/coach_model.dart';
import 'package:fynxfituser/providers/payment_provider.dart';

class CoachDetailsPage extends ConsumerWidget {
  final CoachModel coach;

  const CoachDetailsPage({Key? key, required this.coach}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentNotifier = ref.watch(paymentProvider);

    return Scaffold(
      appBar: AppBar(title: Text(coach.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(coach.profileImage),
                onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 80),
              ),
            ),
            const SizedBox(height: 16),
            Text(coach.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Expertise: ${coach.expertise}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Experience: ${coach.experience}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Bio: ${coach.bio}", style: const TextStyle(fontSize: 16)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Call payment method when user clicks
                paymentNotifier.startPayment("199", "Anuja", "6235713455", "anujajs2002@gmail.com");
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Subscribe for Chat with Coach - ₹199",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
