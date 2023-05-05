import '../domain/enhancement.dart';
import '../domain/game.dart';
import '../domain/game_item.dart';
import '../domain/office.dart';

abstract class NavigationState {}

class OpenEnhancementsState extends NavigationState {
  OpenEnhancementsState(this.enhancements, this.game);

  final List<Enhancement> enhancements;
  final Game game;
}

class OpenGamesState extends NavigationState {
  OpenGamesState(this.games);

  final List<GameItem> games;
}

class ClosedDialogsState extends NavigationState {}
