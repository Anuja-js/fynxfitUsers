import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/models/article_model.dart';
import 'package:fynxfituser/providers/article_provider.dart';
import 'package:fynxfituser/providers/workout_provider.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/article/article_screen.dart';
import 'package:fynxfituser/views/coach/coach_list_page.dart';
import 'package:fynxfituser/views/login/login.dart';
import 'package:fynxfituser/views/workout/workout_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fynxfituser/viewmodels/auth_view_model.dart';

import '../../widgets/customs/custom_text.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: SearchSession(),
                    ),
                    const Icon(Icons.notifications, color: Colors.white),
                    sw10,
                    LogOutSession(authViewModel: authViewModel),
                  ],
                ),
              ),
              const MotivationalText(),
              ProgressCardSession(currentDate: currentDate, hours: hours),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        ref.read(workoutProvider.notifier).fetchWorkouts();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return const WorkoutListPage();
                        }));
                      },
                      child: buildNavItem(
                          Icons.fitness_center, 'Workout', Colors.purple[300]!),
                    ),
                    buildNavItem(
                        Icons.insert_chart, 'Progress\nTracking', Colors.white),
                    buildNavItem(
                        Icons.restaurant_menu, 'Nutrition', Colors.white),
                    InkWell(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                                return const CoachListPage();
                              }));
                        },
                        child: buildNavItem(Icons.people, 'Coaches', Colors.white)),
                  ],
                ),
              ),
              const RecommendationsSession(),
              if (articles.isEmpty) const CustomText(text: "No Articles Found"),
              if (articles.isNotEmpty)
                Cards(articles: articles),
              const WeeklyChallenges()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class WeeklyChallenges extends StatelessWidget {
  const WeeklyChallenges({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(right: 12, top: 12, left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade900,
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Weekly Challenge',
                    fontSize: 18.sp,
                    color: AppThemes.darkTheme.primaryColor,
                  ),
                  CustomText(
                    text: "Plank With Hip Twist",
                    fontSize: 12.sp,
                    color: AppThemes.darkTheme.dividerColor,
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            "assets/images/im1.png",
            width: 100.w,
            height: 120,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.articles,
  });

  final List<ArticleModel> articles;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: articles.length > 2 ? 2 : articles.length,
        itemBuilder: (context, index) {
          final item = articles[index];
          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade900,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              item.subtitle,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              item.createdAt.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RecommendationsSession extends StatelessWidget {
  const RecommendationsSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Articles',
            style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) {
                return const ArticleListPage();
              }));
            },
            child: const Row(
              children: [
                Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 12, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressCardSession extends StatelessWidget {
  const ProgressCardSession({
    super.key,
    required this.currentDate,
    required this.hours,
  });

  final DateTime currentDate;
  final List<double> hours;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Progress',
            style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'January ${currentDate.day}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple[300],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 5,
                interval: 1,
              ),
              series: <ChartSeries>[
                LineSeries<ChartData, String>(
                  dataSource: List.generate(hours.length, (index) {
                    return ChartData(
                        (index + 12).toString(), hours[index]);
                  }),
                  xValueMapper: (ChartData data, _) => data.day,
                  yValueMapper: (ChartData data, _) => data.hours,
                  color: Colors.purple[300],
                  markerSettings:
                      const MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MotivationalText extends StatelessWidget {
  const MotivationalText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade900, Colors.purple.shade300],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: const Text(
        "It's time to challenge your limits.",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class LogOutSession extends StatelessWidget {
  const LogOutSession({
    super.key,
    required this.authViewModel,
  });

  final AuthViewModel authViewModel;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Logout"),
              content: const Text(
                  "Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context)
                        .pop(); // Close the dialog
                    await authViewModel
                        .signOut(); // Sign out the user
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen()),
                    ); // Navigate to LoginScreen
                  },
                  child: const Text("Logout"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class SearchSession extends StatelessWidget {
  const SearchSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          sw10,
          CustomText(
            text: 'Search for Workouts, Diet Plans...',
            fontSize: 12.sp,
            color: AppThemes.darkTheme.dividerColor,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String day;
  final double hours;
  ChartData(this.day, this.hours);
}
