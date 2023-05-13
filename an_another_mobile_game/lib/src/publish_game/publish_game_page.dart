import 'package:an_another_mobile_game/src/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/game.dart';
import '../domain/game_item.dart';
import '../game/game_bloc.dart';
import '../game/game_events.dart';
import '../navigation/navigation_bloc.dart';
import '../navigation/navigation_events.dart';
import '../navigation/navigation_states.dart';

class PublishGameWidget extends StatefulWidget {
  const PublishGameWidget({super.key});

  @override
  PublishGameWidgetState createState() => PublishGameWidgetState();
}

class PublishGameWidgetState extends State<PublishGameWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublishGameBloc, PublishGameState>(
      builder: (context, state) {
        return ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Theme.of(context).primaryColor,
                ),
            itemCount: state.games.length,
            itemBuilder: (BuildContext context, int index) {
              var game = state.games[index];

              return GestureDetector(
                onTap: () => context
                    .read<PublishGameBloc>()
                    .add(GamePublished(game.size)),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(game.title,
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 5),
                    Text('+${game.income.formatCurrency()} per second',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 5),
                    Text('Cost: ${game.cost.formatNumber()} lines',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 5),
                    Text(
                        'Published games: ${state.getPublishedGames(game.size)}'),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            });
      },
    );
  }
}

class PublishGameBloc extends Bloc<PublishGameEvent, PublishGameState> {
  PublishGameBloc(Game game)
      : super(PublishGameState(game.games, game.company.publishedGames)) {
    on<GamePublished>((event, emit) {
      game.publishGame(event.size);
      emit(PublishGameState(game.games, game.company.publishedGames));
    });

    on<UpdatePublishedGames>((event, emit) =>
        emit(PublishGameState(game.games, game.company.publishedGames)));
  }
}

class PublishGameState {
  PublishGameState(this.games, this.publishedGames);

  final List<GameItem> games;
  final List<GameItem> publishedGames;

  int getPublishedGames(GameSize size) =>
      publishedGames.where((element) => element.size == size).length;
}

abstract class PublishGameEvent {}

class GamePublished extends PublishGameEvent {
  GamePublished(this.size);

  final GameSize size;
}

class UpdatePublishedGames extends PublishGameEvent {}

class PublishGamesDialogWidget extends StatelessWidget {
  const PublishGamesDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Dialog(
            child: state is OpenGamesState
                ? Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: 300, child: PublishGameWidget()),
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
