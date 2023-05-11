import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/game.dart';
import 'navigation_events.dart';
import 'navigation_states.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc(Game game) : super(ClosedDialogsState()) {
    on<OpenEnhancementsEvent>((event, emit) =>
        emit(OpenEnhancementsState()));

    on<OpenGamesEvent>((event, emit) => emit(OpenGamesState(game.games)));

    on<OpenCompanyEvent>((event, emit) => emit(OpenCompanyState()));

    on<CloseDialogEvent>((event, emit) => emit(ClosedDialogsState()));

    add(CloseDialogEvent());
  }
}
