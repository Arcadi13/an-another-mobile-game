import '../domain/developer.dart';
import '../domain/game_item.dart';
import '../domain/office.dart';

abstract class GameEvent {}

class GameStarted extends GameEvent {}

class GameTicked extends GameEvent {}

class GameTapped extends GameEvent {}

class GamePublished extends GameEvent {
  GamePublished(this.size);

  final GameSize size;
}

class DeveloperHired extends GameEvent {
  DeveloperHired(this.developerType);

  final DeveloperType developerType;
}

class ToolBought extends GameEvent {}

class OfficeImprovement extends GameEvent {
  OfficeImprovement(this.officeType);

  final OfficeType officeType;
}