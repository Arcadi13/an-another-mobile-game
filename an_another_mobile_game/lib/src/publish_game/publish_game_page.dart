import 'package:an_another_mobile_game/src/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game/game_bloc.dart';
import '../game/game_events.dart';
import '../navigation/navigation_bloc.dart';
import '../navigation/navigation_events.dart';
import '../navigation/navigation_states.dart';

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
                                  '+${state.games[index].income.formatCurrency()} per second',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium),
                              const SizedBox(height: 5),
                              Text(
                                  'Cost: ${state.games[index].cost.formatNumber()} lines',
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