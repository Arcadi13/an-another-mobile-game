import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/game/game_bloc.dart';
import 'src/game/game_page.dart';

void main() {
  Bloc.observer = const GameObserver();
  runApp(GameApp());
}

class GameApp extends MaterialApp {
  GameApp({super.key}) : super(home: GamePage());
}
