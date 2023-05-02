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
                                icon: Icon(
                              Icons.account_circle,
                            )),
                            Tab(icon: Icon(Icons.computer)),
                            Tab(icon: Icon(Icons.house))
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
                                          return GestureDetector(
                                            onTap: () => context
                                                .read<GameBloc>()
                                                .add(DeveloperHired(state
                                                    .developers[index].type)),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                Text(state
                                                    .developers[index].title),
                                                const SizedBox(height: 5),
                                                Text(state.developers[index]
                                                    .description),
                                                const SizedBox(height: 5),
                                                Text(
                                                    'Cost: ${state.developers[index].cost}\$'),
                                                const SizedBox(height: 5),
                                                Text('X/Y hired'),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          );
                                        })),
                                Center(
                                    child: ListView.builder(
                                        itemCount: state.enhancements.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () => context
                                                .read<GameBloc>()
                                                .add(ToolBought(
                                                    state.enhancements[index])),
                                            child: Column(
                                              children: [
                                                Text(state
                                                    .enhancements[index].name
                                                    .toString()),
                                              ],
                                            ),
                                          );
                                        })),
                                Center(
                                    child: ListView.builder(
                                        itemCount: state.offices.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () => context
                                                .read<GameBloc>()
                                                .add(OfficeImprovement(
                                                    state.offices[index].type)),
                                            child: Column(
                                              children: [
                                                Text(state.offices[index].type
                                                    .toString()),
                                              ],
                                            ),
                                          );
                                        }))
                              ],
                            )),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
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
                        child: ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                                  color: Theme.of(context).primaryColor,
                                ),
                            itemCount: state.games.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => context.read<GameBloc>().add(
                                    GamePublished(state.games[index].size)),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(state.games[index].title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                    const SizedBox(height: 5),
                                    Text(
                                        '+${state.games[index].income}\$ per second',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    const SizedBox(height: 5),
                                    Text(
                                        'Cost: ${state.games[index].cost} lines',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              );
                            })),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
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
