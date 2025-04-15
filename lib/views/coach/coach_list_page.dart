import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/viewmodels/coach_view_model.dart';
import 'package:fynxfituser/views/coach/coach_details.dart';

class CoachListPage extends ConsumerWidget {
  const CoachListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coachesState = ref.watch(coachViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Coaches')),
      body: coachesState.when(
        data: (coaches) {
          return ListView.builder(
            itemCount: coaches.length,
            itemBuilder: (context, index) {
              final coach = coaches[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(coach.profileImage),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 40),
                ),
                title: Text(coach.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(coach.expertise, style: const TextStyle(fontSize: 14)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoachDetailsPage(coach: coach),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error")),
      ),

    );
  }
}
