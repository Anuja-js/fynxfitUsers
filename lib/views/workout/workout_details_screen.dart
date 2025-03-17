import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/theme.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/customs/custom_text.dart';

class WorkoutDetailPage extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String videoDescription;

  const WorkoutDetailPage({
    super.key,
    required this.videoUrl,
    required this.videoDescription,
    required this.title,
  });

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: widget.title,
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
        ),
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio ,
                      child: VideoPlayer(_controller),
                    ),
                    sh10,
                    CustomText(
                      text: widget.videoDescription,
                      fontSize: 13.sp,
                      overflow: TextOverflow.visible,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
