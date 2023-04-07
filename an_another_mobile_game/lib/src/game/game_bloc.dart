import 'package:flutter_bloc/flutter_bloc.dart';

import 'game.dart';

class GameObserver extends BlocObserver {
  const GameObserver();
}

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(Game game) : super(GameState(0, 0, 0, 0)) {
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

    on<GamePublished>((event, emit) {
      game.publishGame(event.size);
      emit(state.update(game));
    });

    on<DeveloperHired>((event, emit) {
      game.hireDeveloper(event.developerType);
      emit(state.update(game));
    });

    on<ToolBought>((event, emit) {
      game.toolBought();
      emit(state.update(game));
    });

    on<OfficeImprovement>((event, emit) {
      game.improveOffice();
      emit(state.update(game));
    });

    add(GameStarted());
  }
}

class GameState {
  GameState(this.money, this.lines, this.incomePerSecond, this.linesPerSecond);

  final int money;
  final int lines;
  final int incomePerSecond;
  final int linesPerSecond;

  GameState update(Game game) {
    return GameState(
        game.money, game.lines, game.incomingPerSecond, game.linesPerSecond);
  }
}

abstract class GameEvent {}

class GameStarted extends GameEvent {}

class GameTicked extends GameEvent {}

class GameTapped extends GameEvent {}

class GamePublished extends GameEvent {
  GamePublished(this.size);

  final GameSize size;
}

class DeveloperHired extends GameEvent {
  DeveloperHired(this.developerType);

  final DeveloperType developerType;
}

class ToolBought extends GameEvent {}

class OfficeImprovement extends GameEvent {}
