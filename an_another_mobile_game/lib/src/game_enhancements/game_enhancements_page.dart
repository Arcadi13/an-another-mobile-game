import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game/game.dart';
import '../game/game_bloc.dart';

class GameEnhancementsBloc
    extends Bloc<GameEnhancementsEvent, GameEnhancementsState> {
  GameEnhancementsBloc(Game game) : super(GameEnhancementsClosedState()) {
    on<GameEnhancementsOpenEvent>(
        (event, emit) => emit(GameEnhancementsOpenState()));

    on<GameEnhancementsCloseEvent>(
        (event, emit) => emit(GameEnhancementsClosedState()));

    add(GameEnhancementsCloseEvent());
  }
}

abstract class GameEnhancementsEvent {}

class GameEnhancementsOpenEvent extends GameEnhancementsEvent {}

class GameEnhancementsCloseEvent extends GameEnhancementsEvent {}

abstract class GameEnhancementsState {}

class GameEnhancementsOpenState extends GameEnhancementsState {}

class GameEnhancementsClosedState extends GameEnhancementsState {}

class GameEnhancementsWidget extends StatelessWidget {
  const GameEnhancementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameEnhancementsBloc, GameEnhancementsState>(
        builder: (context, state) {
      return Dialog(
          child: state is GameEnhancementsOpenState
              ? Column(children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                    onPressed: () =>
                        context.read<GameBloc>().add(DeveloperHired()),
                    child: const Text('Hire developer'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                    onPressed: () =>
                        context.read<GameEnhancementsBloc>().add(GameEnhancementsCloseEvent()),
                    child: const Text('Close'),
                  ),
                ])
              : null);
    });
  }
}
