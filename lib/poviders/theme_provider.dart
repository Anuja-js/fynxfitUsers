import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
