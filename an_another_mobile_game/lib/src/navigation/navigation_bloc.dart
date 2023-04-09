import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/game.dart';
import 'navigation_events.dart';
import 'navigation_states.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc(Game game) : super(ClosedDialogsState()) {
    on<OpenEnhancementsEvent>((event, emit) =>
        emit(OpenEnhancementsState(game.developers, game.offices, game.enhancements)));

    on<OpenGamesEvent>((event, emit) => emit(OpenGamesState(game.games)));

    on<CloseDialogEvent>((event, emit) => emit(ClosedDialogsState()));

    add(CloseDialogEvent());
  }
}
