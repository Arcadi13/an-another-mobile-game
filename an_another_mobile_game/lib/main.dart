import 'dart:ui';

import 'package:an_another_mobile_game/src/audio/audio_controller.dart';
import 'package:an_another_mobile_game/src/domain/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'firebase_config.dart';
import 'src/game/game_bloc.dart';
import 'src/game/game_page.dart';
import 'src/settings/persistence/local_storage_settings_persistence.dart';
import 'src/settings/settings.dart';
import 'src/translations/translations_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await TranslationsController().init(window.locale.toLanguageTag());
  await AudioController().initialize();
  final settings =
       SettingsController(persistence: LocalStorageSettingsPersistence());

  await settings.loadStateFromPersistence();

  AudioController().attachSettings(settings);

  GameRecord record = await _getGame(settings);

  Bloc.observer = const GameObserver();
  runApp(GameApp(record, settings));
}

Future<GameRecord> _getGame(SettingsController settings) async {

  String collection;
  String document;

  if(settings.playerName.value != 'none'){
    collection = 'users';
    document = settings.playerName.value;
  } else {
    collection = 'games';
    document = 'default';
    settings.setPlayerName(const Uuid().v1());
  }
  final gameRef = FirebaseFirestore.instance
      .collection(collection)
      .withConverter<GameRecord>(
          fromFirestore: (snapshot, _) => GameRecord.fromJson(snapshot.data()!),
          toFirestore: (game, _) => game.toJson());

  GameRecord record =
      await gameRef.doc(document).get().then((value) => value.data()!);
  return record;
}

class GameApp extends MaterialApp {
  GameApp(GameRecord record, SettingsController settings, {super.key})
      : super(
            home: GamePage(
          game: Game.fromRecord(record),
          settings: settings,
        ));

  static const lightCyan = Color(0xFFD4F3FA);
  static const moonstone = Color(0xFF5FBED0);
  static const charcoal = Color(0xFF0B3D50);
  static const gunmetal = Color(0xFF202F3A);
  static const azureWeb = Color(0xFFEEFEFE);

  @override
  ThemeData? get theme => _customTheme();

  _customTheme() {
    return ThemeData(
        primaryColor: moonstone,
        scaffoldBackgroundColor: gunmetal,
        textTheme: const TextTheme(
            displayMedium: TextStyle(color: gunmetal),
            bodyLarge: TextStyle(color: azureWeb),
            bodyMedium: TextStyle(color: azureWeb)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: gunmetal,
        ),
        dialogTheme: const DialogTheme(backgroundColor: gunmetal),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: azureWeb,
        )),
        iconTheme: const IconThemeData(color: azureWeb));
  }
}
