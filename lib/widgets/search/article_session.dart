import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/article/article_detail_screen.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';

import '../../models/article_model.dart';

class ArticleListsSession extends StatelessWidget {
  const ArticleListsSession({
    super.key,
    required this.articles,
    required this.isDarkMode,
  });

  final List<ArticleModel> articles;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (_, index) {
        final article = articles[index];
        return ListTile(
          leading:Icon(Icons.article_outlined,color: AppThemes.darkTheme.dividerColor,),
          title: CustomText(text: article.title,color: isDarkMode
              ? AppThemes.lightTheme.scaffoldBackgroundColor
              : AppThemes.darkTheme.scaffoldBackgroundColor,fontSize: 12.sp,),
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
    );
  }
}