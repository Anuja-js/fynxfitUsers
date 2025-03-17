import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);

final passwordControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);

final confirmPasswordControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
