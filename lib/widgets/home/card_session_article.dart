import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/models/article_model.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/article/article_screen.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';
import 'package:intl/intl.dart';

class Cards extends StatelessWidget {
  const Cards({super.key, required this.articles, required this.isDark});

  final List<ArticleModel> articles;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 12.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Articles',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppThemes.lightTheme.scaffoldBackgroundColor
                    : AppThemes.darkTheme.scaffoldBackgroundColor,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return const ArticleListPage();
                  }));
                },
                child:  Row(
                  children: [
                    CustomText(text:
                      'See All',
                        color: AppThemes.darkTheme.dividerColor,
                        fontSize: 10.sp,

                    ),
                    Icon(Icons.arrow_forward_ios, size: 10.sp,color:  AppThemes.darkTheme.dividerColor,),
                  ],
                ),
              ),
            ],
          ),
          sh5,
          SizedBox(
            height: 110.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: articles.length > 2 ? 2 : articles.length,
              itemBuilder: (context, index) {
                final item = articles[index];
                return Container(
                  width: 220.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppThemes.darkTheme.dividerColor.withOpacity(0.25),
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
                              width: 80.w,
                              height: 120.h,
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
                                  CustomText(text:
                                  item.title,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp,
                                    color: isDark?AppThemes.lightTheme.scaffoldBackgroundColor:AppThemes.darkTheme.scaffoldBackgroundColor,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  CustomText(
                                    text: item.subtitle,
                                    color:AppThemes.darkTheme.dividerColor,
                                    maxLines: 3,
                                  ),
                                  sh10,
                                  CustomText(
                                    text:  DateFormat('dd/MM/yyyy').format(item.createdAt),
                                    color: AppThemes.darkTheme.dividerColor,
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
        ],
      ),
    );
  }
}
