import 'package:an_another_mobile_game/src/navigation/navigation_events.dart';
import 'package:an_another_mobile_game/src/navigation/navigation_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game/game_bloc.dart';
import '../game/game_events.dart';
import '../game/game_states.dart';
import '../navigation/navigation_bloc.dart';

class GameEnhancementsWidget extends StatefulWidget {
  const GameEnhancementsWidget({Key? key}) : super(key: key);

  @override
  GameEnhancementsWidgetState createState() => GameEnhancementsWidgetState();
}

class GameEnhancementsWidgetState extends State<GameEnhancementsWidget> {
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
                                    child: (BlocBuilder<GameBloc, GameState>(
                                        builder: (context, state2) {
                                  return ListView.builder(
                                      itemCount: state.developers.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (state.game.company.departments
                                                .firstWhere((element) =>
                                                    element.developerType ==
                                                    state
                                                        .developers[index].type)
                                                .size ==
                                            0) {
                                          return Container();
                                        }

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
                                              Text(
                                                  '${state.game.company.departments.firstWhere((element) => element.developerType == state.developers[index].type).hired}/${state.game.company.departments.firstWhere((element) => element.developerType == state.developers[index].type).size} hired'),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                        );
                                      });
                                }))),
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
                                                const SizedBox(height: 10),
                                                Text(state
                                                    .enhancements[index].name
                                                    .toString()),
                                                const SizedBox(height: 5),
                                                Text(state.enhancements[index]
                                                    .description),
                                                const SizedBox(height: 5),
                                                Text(
                                                    'Cost: ${state.enhancements[index].cost}\$'),
                                                const SizedBox(height: 10),
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
                                                const SizedBox(height: 10),
                                                Text(
                                                    state.offices[index].title),
                                                const SizedBox(height: 5),
                                                Text(state.offices[index]
                                                    .description),
                                                const SizedBox(height: 5),
                                                Text(
                                                    'Cost: ${state.developers[index].cost}\$'),
                                                const SizedBox(height: 10),
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
