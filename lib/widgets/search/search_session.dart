
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/providers/article_provider.dart';
import 'package:fynxfituser/providers/workout_provider.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/widgets/customs/custom_text_field.dart';

class SearchFieldSession extends StatelessWidget {
  const SearchFieldSession({
    super.key,
    required this.searchController,
    required this.isDarkMode,
    required this.ref,
  });

  final TextEditingController searchController;
  final bool isDarkMode;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 12.w),
      child: CustomTextField(
        controller: searchController,
        labelText: 'Search Workouts, Articles...',
        textColor:isDarkMode
            ? AppThemes.lightTheme.scaffoldBackgroundColor
            : AppThemes.darkTheme.scaffoldBackgroundColor ,
        onChanged: (value) {
          if (value.isNotEmpty) {
            ref.read(articleProvider.notifier).searchArticles(value);
            ref.read(workoutProvider.notifier).searchWorkouts(value);
          } else {
            ref.read(articleProvider.notifier).fetchArticles();
            ref.read(workoutProvider.notifier).fetchWorkouts();
          }
        },
      ),
    );
  }
}
