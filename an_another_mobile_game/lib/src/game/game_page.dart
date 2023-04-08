import 'package:an_another_mobile_game/src/game_enhancements/game_enhancements_page.dart';
import 'package:an_another_mobile_game/src/navigation/navigation_bloc.dart';
import 'package:an_another_mobile_game/src/navigation/navigation_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game.dart';
import 'game_bloc.dart';
import 'game_events.dart';
import 'game_states.dart';

class GamePage extends StatelessWidget {
  GamePage({super.key});

  final Game game = Game();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<GameBloc>(create: (BuildContext context) => GameBloc(game)),
      BlocProvider<NavigationBloc>(
          create: (BuildContext context) => NavigationBloc(game)),
    ], child: const GameWidget());
  }
}

class GameStatsWidget extends StatelessWidget {
  const GameStatsWidget({super.key, required this.state});

  final GameState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          '${state.money} \$',
          style: theme.textTheme.displayMedium,
        ),
        Text(
          '${state.incomePerSecond} \$ x sec',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          '${state.lines} lines',
          style: theme.textTheme.displayMedium,
        ),
        Text(
          '${state.linesPerSecond} lines x sec',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class GameWidget extends StatelessWidget {
  const GameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            return Scaffold(
                body: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                          image: AssetImage("assets/images/placeholder.jpg"),
                          fit: BoxFit.fitHeight)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GameStatsWidget(state: state),
                      const GameEnhancementsWidget(),
                      const PublishGamesWidget()
                    ],
                  ),
                ),
                floatingActionButton: Stack(
                  children: [
                    Positioned(
                        bottom: 20,
                        right: 20,
                        child: FloatingActionButton(
                          child: const Icon(Icons.add_chart),
                          onPressed: () => context
                              .read<NavigationBloc>()
                              .add(OpenEnhancementsEvent()),
                        )),
                    Positioned(
                        bottom: 20,
                        left: 50,
                        child: FloatingActionButton(
                          child: const Icon(Icons.gamepad_outlined),
                          onPressed: () => context
                              .read<NavigationBloc>()
                              .add(OpenGamesEvent()),
                        ))
                  ],
                ));
          },
        ),
        onTap: () => context.read<GameBloc>().add(GameTapped()));
  }
}
