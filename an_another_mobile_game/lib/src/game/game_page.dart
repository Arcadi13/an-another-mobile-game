import 'package:an_another_mobile_game/src/game_enhancements/game_enhancements_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game.dart';
import 'game_bloc.dart';

class GamePage extends StatelessWidget {
  GamePage({super.key});

  final Game game = Game();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<GameBloc>(create: (BuildContext context) => GameBloc(game)),
      BlocProvider<GameEnhancementsBloc>(
          create: (BuildContext context) => GameEnhancementsBloc(game)),
    ], child: const GameWidget());
  }
}

class GameWidget extends StatelessWidget {
  const GameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      const GameEnhancementsWidget()
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
                              .read<GameEnhancementsBloc>()
                              .add(GameEnhancementsOpenEvent()),
                        )),
                    Positioned(
                        top: 20,
                        right: 20,
                        child: FloatingActionButton(
                          child: const Icon(Icons.gamepad_outlined),
                          onPressed: () => context
                              .read<GameBloc>()
                              .add(GamePublished(GameSize.tiny)),
                        ))
                  ],
                ));
          },
        ),
        onTap: () => context.read<GameBloc>().add(GameTapped()));
  }
}
