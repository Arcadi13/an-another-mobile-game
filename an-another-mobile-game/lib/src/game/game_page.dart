import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game.dart';
import 'game_bloc.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => GameBloc(Game()), child: const GameWidget());
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
                decoration: BoxDecoration(
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
                      onPressed: () => context.read<GameBloc>().add(GamePublished()),
                      child: Text('Publish game'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      onPressed: () => context.read<GameBloc>().add(DeveloperHired()),
                      child: Text('Hire developer'),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        onTap: () => context.read<GameBloc>().add(GameTapped()));
  }
}
