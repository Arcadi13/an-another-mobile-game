import 'dart:async';

import 'package:an_another_mobile_game/src/settings/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/game.dart';
import 'game_events.dart';
import 'game_states.dart';

class GameObserver extends BlocObserver {
  const GameObserver();
}

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(Game game, SettingsController settings)
      : super(GameState(0, 0, 0, 0, 1, 'assets/images/Frame1_Typing.png')) {
    on<GameStarted>((event, emit) async {
      game.timer();
      game.saveData(settings);
      await emit.onEach<Game>(game.tick(), onData: (game) => add(GameTicked()));
    });

    on<GameTicked>((event, emit) => emit(state.update(game)));

    on<GameTapped>((event, emit) {
      game.writeLine();
      var newImage = 'assets/images/Frame1_Typing.png';
      if (state.imagePath == 'assets/images/Frame1_Typing.png') {
        newImage = 'assets/images/Frame2_Typing.png';
      }
      if (state.imagePath == 'assets/images/Frame2_Typing.png') {
        newImage = 'assets/images/Frame3_Typing.png';
      }
      if (state.imagePath == 'assets/images/Frame3_Typing.png') {
        newImage = 'assets/images/Frame4_Typing.png';
      }

      emit(state.updateImage(game.playerProductivity, newImage));
    });

    add(GameStarted());
  }
}
