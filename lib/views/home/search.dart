import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/providers/article_provider.dart';
import 'package:fynxfituser/providers/workout_provider.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';
import 'package:fynxfituser/widgets/search/appbar_session.dart';
import 'package:fynxfituser/widgets/search/search_session.dart';
import 'package:fynxfituser/widgets/search/workout_session.dart';

import '../../widgets/search/article_session.dart';

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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppThemes.darkTheme.scaffoldBackgroundColor
          : AppThemes.lightTheme.scaffoldBackgroundColor,
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width.w,
              MediaQuery.of(context).size.height / 7),
          child: AppBarSession(
              isDarkMode: isDarkMode,
              searchController: searchController,
              tabController: tabController)),
      body: Column(
        children: [
          SearchFieldSession(
              searchController: searchController,
              isDarkMode: isDarkMode,
              ref: ref),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                articles.isNotEmpty
                    ? ArticleListsSession(
                        articles: articles, isDarkMode: isDarkMode)
                    : Center(
                        child: CustomText(
                          text: "Not Found",
                          color: isDarkMode
                              ? AppThemes.lightTheme.scaffoldBackgroundColor
                              : AppThemes.darkTheme.scaffoldBackgroundColor,
                        ),
                      ),
                workouts.isNotEmpty
                    ? WorkoutsListsSession(
                        workouts: workouts, isDarkMode: isDarkMode)
                    : Center(
                        child: CustomText(
                          text: "Not Found",
                          color: isDarkMode
                              ? AppThemes.lightTheme.scaffoldBackgroundColor
                              : AppThemes.darkTheme.scaffoldBackgroundColor,
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
