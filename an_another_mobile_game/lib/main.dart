import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/game/game_bloc.dart';
import 'src/game/game_page.dart';

void main() {
  Bloc.observer = const GameObserver();
  runApp(const GameApp());
}

class GameApp extends MaterialApp {
  const GameApp({super.key}) : super(home: const GamePage());
}
