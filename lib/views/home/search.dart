import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/providers/article_provider.dart';
import 'package:fynxfituser/providers/workout_provider.dart';
import 'package:fynxfituser/views/article/article_detail_screen.dart';
import 'package:fynxfituser/views/home/main_screen.dart';
import 'package:fynxfituser/views/workout/workout_details_screen.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    ref.read(articleProvider.notifier).fetchArticles();
    ref.read(workoutProvider.notifier).fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    final articles = ref.watch(articleProvider);
    final workouts = ref.watch(workoutProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              searchController.clear();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MainScreen(),
                  ));
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            )),
        title: const Text('Explore'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(icon: Icon(Icons.article), text: "Articles"),
            Tab(icon: Icon(Icons.fitness_center), text: "Workouts"),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Workouts, Articles...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
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
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                articles.isNotEmpty
                    ? ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (_, index) {
                          final article = articles[index];
                          return ListTile(
                            leading: const Icon(Icons.article_outlined),
                            title: Text(article.title),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ArticleDetailPage(
                                    articleId: article.documentId,
                                    title: article.title,
                                    subtitle: article.subtitle,
                                    imageUrl: article.imageUrl,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : const Center(
                        child: CustomText(text: "Not Found"),
                      ),
                workouts.isNotEmpty
                    ? ListView.builder(
                        itemCount: workouts.length,
                        itemBuilder: (_, index) {
                          final workout = workouts[index];
                          return ListTile(
                            leading: const Icon(Icons.fitness_center),
                            title: Text(workout.title),
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
                      )
                    : const Center(
                        child: CustomText(text: "Not Found"),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
