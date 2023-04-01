class Game {
  int money = 0;
  int lines = 0;

  int incomingPerSecond = 0;
  int linesPerSecond = 0;

  Stream<Game> tick() {
    return Stream.periodic(const Duration(seconds: 1), (tick) => ticked());
  }

  Game ticked() {
    money = money + incomingPerSecond;
    lines = lines + linesPerSecond;
    return this;
  }

  void writeLine() {
    lines++;
  }

  void publishGame() {
    incomingPerSecond++;
  }

  void hireDeveloper(int developerLines) {
    linesPerSecond += developerLines;
  }
}
