import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/login/login.dart';
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
    final recommendationsProvider =
        StateProvider<List<Map<String, dynamic>>>((ref) => [
              {
                'title': 'Squat Exercise',
                'subtitle': 'Beginner Guide',
                'duration': '15 min',
                'image': 'assets/images/squats.png',
                'isFavorite': true,
              },
              {
                'title': 'Full Body Stretching',
                'subtitle': 'Intermediate',
                'duration': '20 min',
                'image': 'assets/images/squats.png',
                'isFavorite': false,
              },
            ]);

    final hours = ref.watch(hoursProvider);
    final currentDate = ref.watch(currentDateProvider);
    final recommendations = ref.watch(recommendationsProvider);
    final authViewModel = ref.read(authProvider.notifier);
    final user = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
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
                      ),
                    ),
                    const Icon(Icons.notifications, color: Colors.white),
                    sw10,
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await authViewModel.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
          
              // Motivational Text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              ),
          
              // Progress Chart Section
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Progress',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                            markerSettings: const MarkerSettings(isVisible: true),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          
              // Quick Navigation Icons
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildNavItem(
                        Icons.fitness_center, 'Workout', Colors.purple[300]!),
                    buildNavItem(
                        Icons.insert_chart, 'Progress\nTracking', Colors.white),
                    buildNavItem(
                        Icons.restaurant_menu, 'Nutrition', Colors.white),
                    buildNavItem(Icons.people, 'Coaches', Colors.white),
                  ],
                ),
              ),
          
              // Recommendations Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommendations',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Row(
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
                  ],
                ),
              ),
          
              // Recommendation Cards
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    final item = recommendations[index];
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
                                child: Image.asset(
                                  item['image'],
                                  width: 80,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        item['subtitle'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        item['duration'],
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
              ),
                Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(right: 12,top: 12,left: 12),
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
                      text: 'Weekly Challenge',fontSize: 18.sp,color: AppThemes.darkTheme.primaryColor,
                    ),    CustomText(
                      text: "Plank With Hip Twist",fontSize: 12.sp,color: AppThemes.darkTheme.dividerColor,
                    ),
          
          
                  ],
                ),
              ),
            ),
                  Image.asset(
                  "assets/images/im1.png",
                  width:100.w,
                  height: 120,
                  fit: BoxFit.cover,
          
              ),
          
            ],
          ),
                )
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

class ChartData {
  final String day;
  final double hours;
  ChartData(this.day, this.hours);
}
