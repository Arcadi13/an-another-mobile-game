import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/game.dart';
import 'game_events.dart';
import 'game_states.dart';

class GameObserver extends BlocObserver {
  const GameObserver();
}

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(Game game)
      : super(GameState(0, 0, 0, 0, 'assets/images/Programmer_idle.jpg')) {
    on<GameStarted>((event, emit) async {
      game.timer();
      game.saveData();
      await emit.onEach<Game>(game.tick(), onData: (game) => add(GameTicked()));
    });

    on<GameTicked>((event, emit) => emit(state.update(game)));

    on<GameTapped>((event, emit) {
      game.writeLine();
      var newImage = 'assets/images/Programmer_MovingLeftArmk1.jpg';
      if (state.imagePath == 'assets/images/Programmer_MovingLeftArmk1.jpg') {
        newImage = 'assets/images/Programmer_MovingLeftArmk2.jpg';
      }

      emit(state.updateImage(newImage));
    });

    add(GameStarted());
  }
}
