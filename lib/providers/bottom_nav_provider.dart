import 'package:flutter_riverpod/flutter_riverpod.dart';

// State provider to track the current bottom navigation index
final bottomNavProvider = StateProvider<int>((ref) => 0);
