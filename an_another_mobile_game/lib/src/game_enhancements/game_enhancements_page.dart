import 'package:an_another_mobile_game/src/navigation/navigation_events.dart';
import 'package:an_another_mobile_game/src/navigation/navigation_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game/game_bloc.dart';
import '../game/game_events.dart';
import '../navigation/navigation_bloc.dart';

class GameEnhancementsWidget extends StatelessWidget {
  const GameEnhancementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return DefaultTabController(
            length: 3,
            child: Dialog(
                child: state is OpenEnhancementsState
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
                                    child: ListView.builder(
                                        itemCount: state.offices.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.blue,
                                            ),
                                            onPressed: () => context
                                                .read<GameBloc>()
                                                .add(OfficeImprovement(
                                                    state.offices[index].type)),
                                            child: Text(state
                                                .offices[index].type
                                                .toString()),
                                          );
                                        }))
                              ],
                            )),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.blue,
                          ),
                          alignment: Alignment.topRight,
                          onPressed: () => context
                              .read<NavigationBloc>()
                              .add(CloseDialogEvent()),
                        ),
                      ])
                    : null));
      },
    );
  }
}

class PublishGamesWidget extends StatelessWidget {
  const PublishGamesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Dialog(
            child: state is OpenGamesState
                ? Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                        height: 300,
                        child: ListView.builder(
                            itemCount: state.games.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                                onPressed: () => context.read<GameBloc>().add(
                                    GamePublished(state.games[index].size)),
                                child: Text(state.games[index].size.toString()),
                              );
                            })),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.blue,
                      ),
                      alignment: Alignment.topRight,
                      onPressed: () => context
                          .read<NavigationBloc>()
                          .add(CloseDialogEvent()),
                    ),
                  ])
                : null);
      },
    );
  }
}
