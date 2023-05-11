import 'package:an_another_mobile_game/src/domain/enhancement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/game.dart';

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

                if (enhancement.acquired) {
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
          Text(enhancement.name
              .toString()),
          const SizedBox(height: 5),
          Text(enhancement.description),
          const SizedBox(height: 5),
          Text(
              'Cost: ${enhancement.cost}\$'),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class UpgradesBloc extends Bloc<UpgradesEvent, UpgradesState> {
  UpgradesBloc(Game game) : super(UpgradesState(game.enhancements)){
    on<ToolBought>((event, emit) {
      game.toolBought(event.enhancement);
      emit(UpgradesState(game.enhancements));
    });
  }
}

class UpgradesState {
  UpgradesState(this.enhancements);

  final List<Enhancement> enhancements;
}

abstract class UpgradesEvent {}

class ToolBought extends UpgradesEvent {
  ToolBought(this.enhancement);

  final Enhancement enhancement;
}