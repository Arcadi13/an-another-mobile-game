import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/game.dart';
import 'game_events.dart';
import 'game_states.dart';

class GameObserver extends BlocObserver {
  const GameObserver();
}

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(Game game) : super(GameState(0, 0, 0, 0)) {
    on<GameStarted>((event, emit) async {
      game.timer();
      await emit.onEach<Game>(game.tick(), onData: (game) => add(GameTicked()));
    });

    on<GameTicked>((event, emit) => emit(state.update(game)));

    on<GameTapped>((event, emit) => game.writeLine());

    on<GamePublished>((event, emit) => game.publishGame(event.size));

    on<DeveloperHired>(
        (event, emit) => game.hireDeveloper(event.developerType));

    on<ToolBought>((event, emit) => game.toolBought());

    on<OfficeImprovement>(
        (event, emit) => game.improveOffice(event.officeType));

    add(GameStarted());
  }
}
