import 'package:flutter_bloc/flutter_bloc.dart';

import 'game.dart';


class GameObserver extends BlocObserver {
  const GameObserver();
}

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(Game game) : super(GameState(0, 0)) {
    on<GameStarted>((event, emit) async {
      await emit.onEach<Game>(game.tick(),
          onData: (game) => add(GameTicked(game)));
    });

    on<GameTicked>(
        (event, emit) => emit(GameState(event.game.money, event.game.lines)));

    on<GameTapped>(
        (event, emit) => emit(GameState(game.money, game.writeLine())));

    add(GameStarted());
  }
}

class GameState {
  GameState(this.money, this.lines);

  final int money;
  final int lines;
}

abstract class GameEvent {}

class GameStarted extends GameEvent {}

class GameTicked extends GameEvent {
  GameTicked(this.game);

  final Game game;
}

class GameTapped extends GameEvent {}