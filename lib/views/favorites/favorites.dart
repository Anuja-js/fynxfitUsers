import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/providers/favorites_provider.dart';
import 'package:fynxfituser/services/firestore_service.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/article/article_detail_screen.dart';
import 'package:fynxfituser/views/workout/workout_details_screen.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  final String userId;

  const FavoritesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> with SingleTickerProviderStateMixin {
  final FirestoreService firestoreService = FirestoreService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> removeFavorite(String itemId, bool isArticle) async {
    if (isArticle) {
      await firestoreService.toggleFavorite(widget.userId, itemId);
    } else {
      await firestoreService.toggleWorkoutFavorite(widget.userId, itemId);
    }
    ref.invalidate(favoritesProvider); // Refresh data
  }

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(favoritesProvider(widget.userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Articles'),
            Tab(text: 'Workouts'),
          ],
        ),
      ),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text("Error loading favorites.")),
        data: (favorites) {
          final articles = favorites['articles'] ?? [];
          final workouts = favorites['workouts'] ?? [];

          return TabBarView(
            controller: _tabController,
            children: [
              buildFavoritesList(articles, isArticle: true),
              buildFavoritesList(workouts, isArticle: false),
            ],
          );
        },
      ),
    );
  }

  Widget buildFavoritesList(List<Map<String, dynamic>> items, {required bool isArticle}) {
    if (items.isEmpty) {
      return const Center(child: Text('No favorites found.'));
    }

    return ListView.builder(
      itemCount: items.length,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      itemBuilder: (context, index) {
        var item = items[index];

        return Container(
          margin: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            color: AppThemes.darkTheme.cardColor,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(12.w),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                item['imageUrl'] ?? item['thumbUrl'] ?? 'https://icon-library.com/images/empty-icon/empty-icon-19.jpg',
                width: 60.w,
                height: 60.h,
                fit: BoxFit.cover,
              ),
            ),
            title: CustomText(
              text: item['title'] ?? 'No Title',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            subtitle: item['subtitle'] != null
                ? CustomText(
              text: item['subtitle'],
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
                  onPressed: () => removeFavorite(item['documentId'] ?? "", isArticle),
                ),
                Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => isArticle
                      ? ArticleDetailPage(
                    title: item["title"] ?? "",
                    imageUrl: item["imageUrl"] ?? "",
                    subtitle: item["subtitle"] ?? "",
                    articleId: item["documentId"] ?? "",
                  )
                      : WorkoutDetailPage(
                    title: item["title"] ?? "",
                    videoUrl: item["videoUrl"] ?? "",
                    videoDescription: item["subtitle"] ?? "",
                    workoutId: item["documentId"] ?? "",
                    userId: item["userId"] ?? "",
                    advantages: item["advantages"] ?? "",
                    intensity: item["intensity"] ?? "",
                    muscle: item["muscle"] ?? "",
                    sets: item["sets"] ?? "",
                    repetitions: item["repetitions"] ?? "",
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
