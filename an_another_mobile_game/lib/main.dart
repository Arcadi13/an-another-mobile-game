import 'package:an_another_mobile_game/src/domain/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_config.dart';
import 'src/game/game_bloc.dart';
import 'src/game/game_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();

  GameRecord record = await _getGame();

  Bloc.observer = const GameObserver();
  runApp(GameApp(record));
}

Future<GameRecord> _getGame() async {
  final gameRef = FirebaseFirestore.instance.collection('games')
      .withConverter<GameRecord>(
      fromFirestore: (snapshot, _) => GameRecord.fromJson(snapshot.data()!),
      toFirestore: (game, _) => game.toJson());

  GameRecord record = await gameRef.doc('default').get().then((value) => value.data()!);
  return record;
}

class GameApp extends MaterialApp {
  GameApp(GameRecord record, {super.key}) : super(home: GamePage(game: Game.fromRecord(record)));
}

