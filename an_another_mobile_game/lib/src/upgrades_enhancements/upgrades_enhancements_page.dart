import 'package:an_another_mobile_game/src/domain/enhancement.dart';
import 'package:an_another_mobile_game/src/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/game.dart';
import '../translations/translations_controller.dart';

class UpgradesEnhancementsWidget extends StatefulWidget {
  const UpgradesEnhancementsWidget({super.key});

  @override
  UpgradesEnhancementsWidgetState createState() =>
      UpgradesEnhancementsWidgetState();
}

class UpgradesEnhancementsWidgetState extends State<UpgradesEnhancementsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: BlocBuilder<UpgradesBloc, UpgradesState>(builder: (context, state) {
          return ListView.builder(
              itemCount: state.enhancements.length,
              itemBuilder: (BuildContext context, int index) {
                var enhancement = state.enhancements[index];

                if (state.enhancementAcquired(enhancement)) {
                  return Container();
                }

                return _getTile(context, enhancement);
              });
        }));
  }

  GestureDetector _getTile(BuildContext context, Enhancement enhancement) {
    return GestureDetector(
      onTap: () =>
          context.read<UpgradesBloc>().add(ToolBought(enhancement)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(TranslationsController()
              .getTranslation(enhancement.name)
              .toString()),
          const SizedBox(height: 5),
          Text(TranslationsController()
              .getTranslation(enhancement.description)),
          const SizedBox(height: 5),
          Text(TranslationsController()
              .getTranslation('costLabel')
              .format([enhancement.cost.formatCurrency()])),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class UpgradesBloc extends Bloc<UpgradesEvent, UpgradesState> {
  UpgradesBloc(Game game) : super(UpgradesState(game.enhancements, game.acquiredEnhancements)){
    on<ToolBought>((event, emit) {
      game.toolBought(event.enhancement);
      emit(UpgradesState(game.enhancements, game.acquiredEnhancements));
    });
  }
}

class UpgradesState {
  UpgradesState(this.enhancements, this.acquiredEnhancements);

  final List<Enhancement> enhancements;
  final List<Enhancement> acquiredEnhancements;

  bool enhancementAcquired(Enhancement enhancement) => acquiredEnhancements.contains(enhancement);
}

abstract class UpgradesEvent {}

class ToolBought extends UpgradesEvent {
  ToolBought(this.enhancement);

  final Enhancement enhancement;
}