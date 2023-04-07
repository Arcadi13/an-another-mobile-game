import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game/game.dart';
import '../game/game_bloc.dart';

class GameEnhancementsBloc
    extends Bloc<GameEnhancementsEvent, GameEnhancementsState> {
  GameEnhancementsBloc(Game game) : super(GameEnhancementsClosedState()) {
    on<GameEnhancementsOpenEvent>(
        (event, emit) => emit(GameEnhancementsOpenState(game.hiring)));

    on<GameEnhancementsCloseEvent>(
        (event, emit) => emit(GameEnhancementsClosedState()));

    add(GameEnhancementsCloseEvent());
  }
}

abstract class GameEnhancementsEvent {}

class GameEnhancementsOpenEvent extends GameEnhancementsEvent {}

class GameEnhancementsCloseEvent extends GameEnhancementsEvent {}

abstract class GameEnhancementsState {}

class GameEnhancementsOpenState extends GameEnhancementsState {
  GameEnhancementsOpenState(this.developers);

  final List<Developer> developers;
}

class GameEnhancementsClosedState extends GameEnhancementsState {}

class GameEnhancementsWidget extends StatelessWidget {
  const GameEnhancementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameEnhancementsBloc, GameEnhancementsState>(
        builder: (context, state) {
      return DefaultTabController(
          length: 3,
          child: Dialog(
              child: state is GameEnhancementsOpenState
                  ? Column(mainAxisSize: MainAxisSize.min, children: [
                      const TabBar(
                        tabs: [
                          Tab(
                              icon: Icon(Icons.account_circle,
                                  color: Colors.blue)),
                          Tab(icon: Icon(Icons.computer, color: Colors.blue)),
                          Tab(icon: Icon(Icons.house, color: Colors.blue))
                        ],
                        isScrollable: false,
                      ),
                      SizedBox(
                          height: 300,
                          child: TabBarView(
                            children: [
                              Center(
                                  child: ListView.builder(
                                      itemCount: state.developers.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.blue,
                                          ),
                                          onPressed: () => context
                                              .read<GameBloc>()
                                              .add(DeveloperHired(state
                                                  .developers[index].type)),
                                          child: Text(
                                              state.developers[index].title),
                                        );
                                      })),
                              Center(
                                  child: Column(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                    ),
                                    onPressed: () => context
                                        .read<GameBloc>()
                                        .add(ToolBought()),
                                    child: const Text('Buy hardware'),
                                  ),
                                ],
                              )),
                              Center(
                                  child: Column(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                    ),
                                    onPressed: () => context
                                        .read<GameBloc>()
                                        .add(OfficeImprovement()),
                                    child: const Text('Buy office'),
                                  ),
                                ],
                              ))
                            ],
                          )),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.blue,
                        ),
                        alignment: Alignment.topRight,
                        onPressed: () => context
                            .read<GameEnhancementsBloc>()
                            .add(GameEnhancementsCloseEvent()),
                      ),
                    ])
                  : null));
    });
  }
}
