// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/providers/article_provider.dart';
import 'package:fynxfituser/providers/workout_provider.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/coach/coach_list_page.dart';
import 'package:fynxfituser/views/home/search.dart';
import 'package:fynxfituser/views/login/login.dart';
import 'package:fynxfituser/views/workout/workout_screen.dart';
import 'package:fynxfituser/widgets/home/card_session_article.dart';
import 'package:fynxfituser/widgets/home/progress_card_session.dart';
import 'package:fynxfituser/widgets/home/weekly_challenge.dart';
import 'package:fynxfituser/viewmodels/auth_view_model.dart';
import '../../widgets/customs/custom_text.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hoursProvider =
        StateProvider<List<double>>((ref) => [2.5, 3.8, 2.1, 3.2, 2.7, 1.4]);
    final currentDateProvider =
        StateProvider<DateTime>((ref) => DateTime.now());
    final articles = ref.watch(articleProvider);
    final hours = ref.watch(hoursProvider);
    final currentDate = ref.watch(currentDateProvider);
    final authViewModel = ref.read(authProvider.notifier);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode
          ? AppThemes.darkTheme.scaffoldBackgroundColor
          : AppThemes.lightTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildAppBar(context, authViewModel, ref, isDarkMode),
            ProgressCardSession(
              currentDate: currentDate,
              hours: hours,
              isDark: isDarkMode,
            ),
            rowSession(context, ref, isDarkMode),
            if (articles.isEmpty)
              CustomText(
                text: "No Articles Found",
                color: isDarkMode
                    ? AppThemes.lightTheme.scaffoldBackgroundColor
                    : AppThemes.darkTheme.scaffoldBackgroundColor,
              ),
            if (articles.isNotEmpty) Cards(articles: articles,isDark: isDarkMode,),
            const WeeklyChallenges()
          ],
        ),
      ),
    );
  }

  Widget rowSession(BuildContext context, WidgetRef ref, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              ref.read(workoutProvider.notifier).fetchWorkouts();
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return const WorkoutListPage();
              }));
            },
            child: buildNavItem(Icons.fitness_center, 'Workout',
                AppThemes.darkTheme.primaryColor, isDark),
          ),
          buildNavItem(Icons.insert_chart, 'Progress\nTracking',
              AppThemes.darkTheme.primaryColor, isDark),
          buildNavItem(Icons.restaurant_menu, 'Nutrition',
              AppThemes.darkTheme.primaryColor, isDark),
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return const CoachListPage();
                }));
              },
              child: buildNavItem(Icons.people, 'Coaches',
                  AppThemes.darkTheme.primaryColor, isDark)),
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context, AuthViewModel authViewModel,
      WidgetRef ref, bool isDark) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppThemes.darkTheme.primaryColor,
        gradient: LinearGradient(
          colors: [Colors.black, AppThemes.darkTheme.primaryColor],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 45.h,
                  width: MediaQuery.of(context).size.width / 1.5,
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppThemes.lightTheme.scaffoldBackgroundColor
                        : AppThemes.darkTheme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: CustomText(
                      text: 'Search Workouts, Articles..',
                      color: isDark
                          ? AppThemes.darkTheme.scaffoldBackgroundColor
                          : AppThemes.lightTheme.scaffoldBackgroundColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.notifications, size: 20.sp),
                  onPressed: () {},
                  tooltip: 'Notifications',
                  color: isDark
                      ? AppThemes.darkTheme.scaffoldBackgroundColor
                      : AppThemes.lightTheme.scaffoldBackgroundColor,
                ),
                IconButton(
                  tooltip: "LogOut",
                  icon: Icon(
                    Icons.logout,
                    size: 20.sp,
                    color: isDark
                        ? AppThemes.darkTheme.scaffoldBackgroundColor
                        : AppThemes.lightTheme.scaffoldBackgroundColor,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: CustomText(
                            text: "Confirm Logout",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppThemes.lightTheme.scaffoldBackgroundColor
                                : AppThemes.darkTheme.scaffoldBackgroundColor,
                          ),
                          content: CustomText(
                            text: "Are you sure you want to logout?",
                            color: isDark
                                ? AppThemes.lightTheme.scaffoldBackgroundColor
                                : AppThemes.darkTheme.scaffoldBackgroundColor,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: CustomText(
                                text: "Cancel",
                                color: isDark
                                    ? AppThemes
                                        .lightTheme.scaffoldBackgroundColor
                                    : AppThemes
                                        .darkTheme.scaffoldBackgroundColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await authViewModel.signOut();
                                Navigator.pushReplacement(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                              child: CustomText(
                                text: "Logout",
                                color: isDark
                                    ? AppThemes
                                        .lightTheme.scaffoldBackgroundColor
                                    : AppThemes
                                        .darkTheme.scaffoldBackgroundColor,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          sh20,
          CustomText(
            text: "It's time to challenge your limits.",
            color: isDark
                ? AppThemes.lightTheme.scaffoldBackgroundColor
                : AppThemes.darkTheme.scaffoldBackgroundColor,
          ),
        ],
      ),
    );
  }

  Widget buildNavItem(IconData icon, String label, Color color, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 25.sp),
        ),
        sh5,
        CustomText(
          text: label,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
          color: isDark
              ? AppThemes.lightTheme.scaffoldBackgroundColor
              : AppThemes.darkTheme.scaffoldBackgroundColor,
        ),
      ],
    );
  }
}
