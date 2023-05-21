import '../domain/game.dart';

class GameState {
  GameState(this.money, this.lines, this.incomePerSecond, this.linesPerSecond, this.imagePath);

  final int money;
  final int lines;
  final int incomePerSecond;
  final int linesPerSecond;
  final String imagePath;

  GameState update(Game game) {
    return GameState(
        game.money, game.lines, game.incomingPerSecond, game.linesPerSecond, imagePath);
  }

  GameState updateImage(String newImagePath){
    return GameState(
        money, lines, incomePerSecond, linesPerSecond, newImagePath);
  }
}
