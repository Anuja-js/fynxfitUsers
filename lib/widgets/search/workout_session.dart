import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/models/workout_model.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/workout/workout_details_screen.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';

class WorkoutsListsSession extends StatelessWidget {
  const WorkoutsListsSession({
    super.key,
    required this.workouts,
    required this.isDarkMode,
  });

  final List<WorkoutModel> workouts;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (_, index) {
        final workout = workouts[index];
        return ListTile(
          leading:Icon(Icons.fitness_center,color: AppThemes.darkTheme.dividerColor,),
          title: CustomText(text: workout.title,color: isDarkMode
              ? AppThemes.lightTheme.scaffoldBackgroundColor
              : AppThemes.darkTheme.scaffoldBackgroundColor,fontSize: 12.sp,),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WorkoutDetailPage(
                  workoutId: workout.documentId,
                  videoUrl: workout.videoUrl,
                  intensity: workout.intensity,
                  videoDescription: workout.description,
                  title: workout.title,
                  userId: workout.userId,
                  muscle: workout.muscle,
                  sets: workout.sets,
                  repetitions: workout.repetitions,
                  advantages: workout.advantages,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
