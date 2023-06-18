import 'package:an_another_mobile_game/src/audio/audio_controller.dart';
import 'package:an_another_mobile_game/src/audio/sounds.dart';
import 'package:an_another_mobile_game/src/developer_enhancements/developer_enhencements_page.dart';
import 'package:an_another_mobile_game/src/game_enhancements/game_enhancements_page.dart';
import 'package:an_another_mobile_game/src/helpers/extensions.dart';
import 'package:an_another_mobile_game/src/navigation/navigation_bloc.dart';
import 'package:an_another_mobile_game/src/navigation/navigation_events.dart';
import 'package:an_another_mobile_game/src/upgrades_enhancements/upgrades_enhancements_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../company/game_career.dart';
import '../domain/game.dart';
import '../navigation/navigation_states.dart';
import '../office_enhancements/office_enhancements_page.dart';
import '../publish_game/publish_game_page.dart';
import '../settings/settings.dart';
import '../settings/settings_screen.dart';
import 'game_bloc.dart';
import 'game_events.dart';
import 'game_states.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.game, required this.settings});

  final Game game;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<GameBloc>(
              create: (BuildContext context) => GameBloc(game, settings)),
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
          BlocProvider<PublishGameBloc>(
              create: (BuildContext context) => PublishGameBloc(game)),
        ],
        child: GameWidget(
          settings: settings,
        ));
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
          state.money.formatCurrency(),
          style: theme.textTheme.displayMedium,
        ),
        Text(
          '${state.incomePerSecond.formatCurrency()} x sec',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          '${state.lines.formatNumber()} lines',
          style: theme.textTheme.displayMedium,
        ),
        Text(
          '${state.linesPerSecond.formatNumber()} lines x sec',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class GameWidget extends StatefulWidget {
  final SettingsController settings;

  GameWidget({Key? key, required this.settings}) : super(key: key);

  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(_controller);
    _controller.forward(from: 0.0);

    super.initState();
  }

  void startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (context.read<NavigationBloc>().state is ClosedDialogsState) {
              context.read<GameBloc>().add(GameTapped());
              AudioController().playSfx(SfxType.typing);
              startAnimation();
            }
          },
          child: Scaffold(
              body: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                        image: AssetImage(state.imagePath),
                        fit: BoxFit.fitHeight)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GameStatsWidget(state: state),
                    const GameEnhancementsWidget(),
                    const PublishGamesDialogWidget(),
                    const CompanyWidget(),
                    SettingsScreen(settings: widget.settings),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FadeOutText(
                        text:
                            '+ ${state.playerProductivity.formatNumber()} lines',
                        style: Theme.of(context).textTheme.displayMedium,
                        opacityAnimation: _opacityAnimation,
                      ),
                    )
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
                      )),
                  Positioned(
                      top: 50,
                      right: 20,
                      child: FloatingActionButton(
                        mini: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Icon(Icons.settings),
                        onPressed: () => context
                            .read<NavigationBloc>()
                            .add(OpenSettingsEvent()),
                      ))
                ],
              )),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FadeOutText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Animation<double> opacityAnimation;

  FadeOutText(
      {Key? key,
      required this.text,
      required this.style,
      required this.opacityAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Text(
            text,
            style: style,
          ),
        );
      },
    );
  }
}
