import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/providers/favorites_provider.dart';
import 'package:fynxfituser/services/firestore_service.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';
import 'package:video_player/video_player.dart';

class WorkoutDetailPage extends ConsumerStatefulWidget {
  final String videoUrl;
  final String title;
  final String videoDescription;
  final String workoutId;
  final String userId;
  final String advantages;
  final String intensity;
  final String muscle;
  final String sets;
  final String repetitions;

  const WorkoutDetailPage({
    super.key,
    required this.videoUrl,
    required this.videoDescription,
    required this.title,
    required this.workoutId,
    required this.userId,
    required this.intensity,
    required this.sets,
    required this.repetitions,
    required this.muscle,
    required this.advantages,
  });

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends ConsumerState<WorkoutDetailPage> {
  late VideoPlayerController controller;
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });

    firestoreService.checkWorkoutFavorite(
        FirebaseAuth.instance.currentUser!.uid, widget.workoutId);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar( backgroundColor:AppThemes.darkTheme.scaffoldBackgroundColor,
        title: CustomText(text: widget.title, fontWeight: FontWeight.bold,fontSize: 15.sp,),
        elevation: 0,
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: firestoreService.isFavoriteNotifier,
            builder: (context, isFavorite, child) {
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.yellow : Colors.white,
                ),
                onPressed: () {
                  firestoreService.toggleWorkoutFavorite(
                      FirebaseAuth.instance.currentUser!.uid, widget.workoutId);
                  ref
                      .read(favoritesProvider(
                      FirebaseAuth.instance.currentUser!.uid)
                      .notifier)
                      .fetchFavorites();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: AppThemes.darkTheme.appBarTheme.foregroundColor!.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: controller.value.isInitialized
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              )
                  : const Center(child: CircularProgressIndicator()),
            ),
          sh20,
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemes.darkTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
                onPressed: () {
                  setState(() {
                    controller.value.isPlaying ? controller.pause() : controller.play();
                  });
                },
                child: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 30.sp,
                ),
              ),
            ),
           sh20,
            buildInfoCard("Advantages", widget.advantages),
            buildInfoCard("Sets", widget.sets),
            buildInfoCard("Repetitions", widget.repetitions),
            buildInfoCard("Intensity", widget.intensity),
            buildInfoCard("Muscle Targeted", widget.muscle),
            buildInfoCard("Description", widget.videoDescription),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(String label, String value) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text:
              label,
              fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,

            ),
          sw5,
            SizedBox(width: MediaQuery.of(context).size.width/2,
              child: CustomText(text:
                value,overflow: TextOverflow.visible,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
