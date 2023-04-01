import 'package:flutter_bloc/flutter_bloc.dart';

import 'game.dart';

class GameObserver extends BlocObserver {
  const GameObserver();
}

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(Game game) : super(GameState(0, 0)) {
    on<GameStarted>((event, emit) async {
      await emit.onEach<Game>(game.tick(), onData: (game) => add(GameTicked()));
    });

    on<GameTicked>((event, emit) => emit(state.update(game)));

    on<GameTapped>(
      (event, emit) {
        game.writeLine();
        emit(state.update(game));
      },
    );

    on<GamePublished>((event, emit) => game.publishGame());

    on<DeveloperHired>((event, emit) => game.hireDeveloper(5));

    add(GameStarted());
  }
}

class GameState {
  GameState(this.money, this.lines);

  final int money;
  final int lines;

  GameState update(Game game) {
    return GameState(game.money, game.lines);
  }
}

abstract class GameEvent {}

class GameStarted extends GameEvent {}

class GameTicked extends GameEvent {}

class GameTapped extends GameEvent {}

class GamePublished extends GameEvent {}

class DeveloperHired extends GameEvent {}
