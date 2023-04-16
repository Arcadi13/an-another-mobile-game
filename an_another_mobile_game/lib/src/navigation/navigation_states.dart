import '../domain/developer.dart';
import '../domain/enhancement.dart';
import '../domain/game_item.dart';
import '../domain/office.dart';

abstract class NavigationState {}

class OpenEnhancementsState extends NavigationState {
  OpenEnhancementsState(this.developers, this.offices, this.enhancements);

  final List<Developer> developers;
  final List<Office> offices;
  final List<Enhancement> enhancements;
}

class OpenGamesState extends NavigationState {
  OpenGamesState(this.games);

  final List<GameItem> games;
}

class ClosedDialogsState extends NavigationState {}
