
class Game {
  int money = 0;
  int lines = 0;

  int incomingPerSecond = 10;
  int linesPerSecond = 0;

  Stream<Game> tick() {
    return Stream.periodic(const Duration(seconds: 1), (tick) => ticked());
  }

  Game ticked() {
    money = money + incomingPerSecond;
    lines = lines + linesPerSecond;
    return this;
  }

  int writeLine() {
    return lines++;
  }
}