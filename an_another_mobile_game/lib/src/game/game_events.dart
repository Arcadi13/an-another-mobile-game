import 'package:an_another_mobile_game/src/domain/enhancement.dart';

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
