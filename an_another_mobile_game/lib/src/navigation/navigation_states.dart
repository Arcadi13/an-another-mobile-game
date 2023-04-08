
import '../game/game.dart';

abstract class NavigationState {}

class OpenEnhancementsState extends NavigationState {
  OpenEnhancementsState(this.developers);

  final List<Developer> developers;
}

class OpenGamesState extends NavigationState {
  OpenGamesState(this.games);

  final List<GameItem> games;
}

class ClosedDialogsState extends NavigationState {}