import '../domain/game.dart';

class GameState {
  GameState(this.money, this.lines, this.incomePerSecond, this.linesPerSecond);

  final int money;
  final int lines;
  final int incomePerSecond;
  final int linesPerSecond;

  GameState update(Game game) {
    return GameState(
        game.money, game.lines, game.incomingPerSecond, game.linesPerSecond);
  }
}
