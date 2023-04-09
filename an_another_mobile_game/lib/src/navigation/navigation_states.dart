import '../domain/developer.dart';
import '../domain/game_item.dart';
import '../domain/office.dart';

abstract class NavigationState {}

class OpenEnhancementsState extends NavigationState {
  OpenEnhancementsState(this.developers, this.offices);

  final List<Developer> developers;
  final List<Office> offices;
}

class OpenGamesState extends NavigationState {
  OpenGamesState(this.games);

  final List<GameItem> games;
}

class ClosedDialogsState extends NavigationState {}
