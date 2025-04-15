import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/viewmodels/fitness_goal_view_model.dart';
import 'package:fynxfituser/views/workout/workout_details_screen.dart';

import '../../models/workout_model.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/customs/custom_text.dart';

class WorkoutListPage extends ConsumerWidget {
  const WorkoutListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Plans"),actions: [IconButton(onPressed: (){
        showSheet(context, ref);
      }, icon: Icon(Icons.sort))],
      ),
      body: workouts.isEmpty
          ? const Center(child: CustomText(text: "Not found"))
          : ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final WorkoutModel workout = workouts[index];
          return WorkoutCard(workout: workout); //  FIXED
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(workoutProvider.notifier).fetchWorkouts(),
        child: const Icon(Icons.refresh),
      ),
    );

  }
  void showSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final fitnessGoals = ref.watch(fitnessGoalViewModelProvider);

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: fitnessGoals.when(
            data: (goals) =>
                ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return ListTile(onTap: (){
                      ref.read(workoutProvider.notifier).sort(goal.title);
                      Navigator.pop(context);
                    },
                      title: Text(goal.title ?? "No Name"),
                    );
                  },
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text("Error: $error")),
          ),
        );
      },
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WorkoutDetailPage(
                  title: workout.title ?? "",
                  videoUrl: workout.videoUrl ?? "",
                  videoDescription: workout.description ?? "",
                  workoutId: workout.documentId ?? "",
                  userId: workout.userId ?? "",
                  advantages: workout.advantages ?? "",
                  intensity: workout.intensity ?? "",
                  muscle: workout.muscle ?? "",
                  sets: workout.sets ?? "",
                  repetitions: workout.repetitions ?? "",
                ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4,
        child: ListTile(
          title: CustomText(text: workout.title ?? ""), //  FIXED
          trailing: const Icon(Icons.play_circle_fill, color: Colors.blue),
        ),
      ),
    );
  }


}