import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/game.dart';
import '../navigation/navigation_bloc.dart';
import '../navigation/navigation_events.dart';
import '../navigation/navigation_states.dart';

class CompanyWidget extends StatelessWidget {
  const CompanyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return DefaultTabController(
            length: 3,
            child: Dialog(
                child: state is OpenCompanyState
                    ? Column(mainAxisSize: MainAxisSize.min, children: [
                        const TabBar(
                          tabs: [
                            Tab(
                                icon: Icon(
                              Icons.candlestick_chart_outlined,
                            )),
                            Tab(icon: Icon(Icons.computer)),
                            Tab(icon: Icon(Icons.house))
                          ],
                          isScrollable: false,
                        ),
                        const SizedBox(
                            height: 300,
                            child: TabBarView(
                              children: [
                                SellCompanyWidget(),
                                PartnersWidget(),
                                CareerStatsWidget()
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

class CareerStatsWidget extends StatelessWidget {
  const CareerStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PartnersWidget extends StatelessWidget {
  const PartnersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SellCompanyWidget extends StatelessWidget {
  const SellCompanyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellCompanyBloc, SellCompanyState>(
        builder: (context, state) {
      return Center(
        child: Column(
          children: [
            Text('You can sell your company and get ${state.getValue()} stocks'),
            FilledButton(
                onPressed: () =>
                    context.read<SellCompanyBloc>().add(SellCompanyEvent()),
                child: const Text('Sell'))
          ],
        ),
      );
    });
  }
}

class SellCompanyState {
  SellCompanyState(this.game);

  final Game game;

  int getValue(){
    return game.companyValue();
  }
}

class SellCompanyBloc extends Bloc<SellCompanyEvent, SellCompanyState> {
  SellCompanyBloc(Game game) : super(SellCompanyState(game)) {
    on<SellCompanyEvent>((event, emit) {
      game.sellCompany();
      emit(SellCompanyState(game));
    });
  }
}

class SellCompanyEvent {}
