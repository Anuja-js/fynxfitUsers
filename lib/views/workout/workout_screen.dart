import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/views/workout/workout_details_screen.dart';

import '../../models/workout_model.dart';
import '../../providers/workout_provider.dart';
class WorkoutListPage extends ConsumerWidget {
  const WorkoutListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Plans"),
      ),
      body: workouts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final WorkoutModel workout = workouts[index];
          return WorkoutCard(
            title: workout.title,
            description: workout.description,
            videoUrl: workout.videoUrl,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(workoutProvider.notifier).fetchWorkouts(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String videoUrl;
  final String description;

  const WorkoutCard({super.key, required this.title, required this.videoUrl,required this.description});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to WorkoutDetailPage when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailPage(videoUrl: videoUrl,videoDescription:description,title:title),
          ),
        );

      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4,
        child: ListTile(
          title: Text(title),
          trailing: const Icon(Icons.play_circle_fill, color: Colors.blue),
        ),
      ),
    );
  }
}
