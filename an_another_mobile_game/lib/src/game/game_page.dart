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
                      '${state.lines} code lines',
                      style: theme.textTheme.displayMedium,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      onPressed: () =>
                          context.read<GameBloc>().add(GamePublished()),
                      child: const Text('Publish game'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      onPressed: () => context
                          .read<GameEnhancementsBloc>()
                          .add(GameEnhancementsOpenEvent()),
                      child: const Text('Hire developer'),
                    ),
                    const GameEnhancementsWidget()
                  ],
                ),
              ),
            );
          },
        ),
        onTap: () => context.read<GameBloc>().add(GameTapped()));
  }
}
