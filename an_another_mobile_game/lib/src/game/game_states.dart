import '../domain/game.dart';

class GameState {
  GameState(this.money, this.lines, this.incomePerSecond, this.linesPerSecond, this.playerProductivity, this.imagePath);

  final int money;
  final int lines;
  final int incomePerSecond;
  final int linesPerSecond;
  final int playerProductivity;
  final String imagePath;

  GameState update(Game game) {
    return GameState(
        game.money, game.lines, game.incomingPerSecond, game.linesPerSecond, game.playerProductivity.round(), imagePath);
  }

  GameState updateImage(double playerProductivity, String newImagePath){
    return GameState(
        money, lines, incomePerSecond, linesPerSecond, playerProductivity.round(), newImagePath);
  }
}
