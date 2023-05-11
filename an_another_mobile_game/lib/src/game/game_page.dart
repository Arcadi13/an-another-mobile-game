import 'package:an_another_mobile_game/src/developer_enhancements/developer_enhencements_page.dart';
import 'package:an_another_mobile_game/src/game_enhancements/game_enhancements_page.dart';
import 'package:an_another_mobile_game/src/navigation/navigation_bloc.dart';
import 'package:an_another_mobile_game/src/navigation/navigation_events.dart';
import 'package:an_another_mobile_game/src/upgrades_enhancements/upgrades_enhancements_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../company/game_career.dart';
import '../domain/game.dart';
import '../office_enhancements/office_enhancements_page.dart';
import '../publish_game/publish_game_page.dart';
import 'game_bloc.dart';
import 'game_events.dart';
import 'game_states.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<GameBloc>(create: (BuildContext context) => GameBloc(game)),
      BlocProvider<NavigationBloc>(
          create: (BuildContext context) => NavigationBloc(game)),
      BlocProvider<DeveloperBloc>(
          create: (BuildContext context) => DeveloperBloc(game)),
      BlocProvider<OfficeBloc>(
          create: (BuildContext context) => OfficeBloc(game)),
      BlocProvider<UpgradesBloc>(
          create: (BuildContext context) => UpgradesBloc(game)),
      BlocProvider<SellCompanyBloc>(
          create: (BuildContext context) => SellCompanyBloc(game)),
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
                      const PublishGamesWidget(),
                      const CompanyWidget()
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
                        )),
                    Positioned(
                        top: 50,
                        left: 50,
                        child: FloatingActionButton(
                          mini: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: const Icon(Icons.account_balance),
                          onPressed: () => context
                              .read<NavigationBloc>()
                              .add(OpenCompanyEvent()),
                        ))
                  ],
                ));
          },
        ),
        onTap: () => context.read<GameBloc>().add(GameTapped()));
  }
}
