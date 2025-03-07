import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class IconSplashImage extends ConsumerWidget {
  const IconSplashImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Image.asset(
      "assets/images/logo_white.png",
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 3,
    );
  }
}
