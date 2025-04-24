
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/home/main_screen.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';

class AppBarSession extends StatelessWidget {
  const AppBarSession({
    super.key,
    required this.isDarkMode,
    required this.searchController,
    required this.tabController,
  });

  final bool isDarkMode;
  final TextEditingController searchController;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isDarkMode
          ? AppThemes.darkTheme.scaffoldBackgroundColor
          : AppThemes.lightTheme.scaffoldBackgroundColor,
      leading: IconButton(
          onPressed: () {
            searchController.clear();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const MainScreen(),
                ));
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            color: isDarkMode
                ? AppThemes.lightTheme.scaffoldBackgroundColor
                : AppThemes.darkTheme.scaffoldBackgroundColor,
          )),
      title: CustomText(text: 'Explore',color:  isDarkMode
          ? AppThemes.lightTheme.scaffoldBackgroundColor
          : AppThemes.darkTheme.scaffoldBackgroundColor,fontSize: 18.sp,fontWeight: FontWeight.bold,),
      bottom: TabBar(dividerColor: AppThemes.darkTheme.dividerColor,
        unselectedLabelColor: AppThemes.darkTheme.dividerColor,
        indicatorColor: AppThemes.darkTheme.primaryColor,
        labelColor: AppThemes.darkTheme.primaryColor,
        controller: tabController,
        tabs: const [
          Tab(icon: Icon(Icons.article,), text: "Articles",),
          Tab(icon: Icon(Icons.fitness_center,), text: "Workouts"),
        ],
      ),
    );
  }
}