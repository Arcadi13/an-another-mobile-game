import 'package:an_another_mobile_game/src/developer_enhancements/developer_enhencements_page.dart';
import 'package:an_another_mobile_game/src/navigation/navigation_events.dart';
import 'package:an_another_mobile_game/src/navigation/navigation_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game/game_bloc.dart';
import '../game/game_events.dart';
import '../navigation/navigation_bloc.dart';
import '../office_enhancements/office_enhancements_page.dart';

class GameEnhancementsWidget extends StatelessWidget {
  const GameEnhancementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return DefaultTabController(
            length: 3,
            child: Dialog(
                child: state is OpenEnhancementsState
                    ? Column(mainAxisSize: MainAxisSize.min, children: [
                        const TabBar(
                          tabs: [
                            Tab(
                                icon: Icon(
                              Icons.account_circle,
                            )),
                            Tab(icon: Icon(Icons.computer)),
                            Tab(icon: Icon(Icons.house))
                          ],
                          isScrollable: false,
                        ),
                        SizedBox(
                            height: 300,
                            child: TabBarView(
                              children: [
                                const DeveloperEnhancementsWidget(),
                                Center(
                                    child: ListView.builder(
                                        itemCount: state.enhancements.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () => context
                                                .read<GameBloc>()
                                                .add(ToolBought(
                                                    state.enhancements[index])),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                Text(state
                                                    .enhancements[index].name
                                                    .toString()),
                                                const SizedBox(height: 5),
                                                Text(state.enhancements[index]
                                                    .description),
                                                const SizedBox(height: 5),
                                                Text(
                                                    'Cost: ${state.enhancements[index].cost}\$'),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          );
                                        })),
                                const OfficeEnhancementsWidget()
                              ],
                            )),
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
                    : null));
      },
    );
  }
}
