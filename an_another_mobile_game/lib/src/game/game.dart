class Game {
  int money = 0;
  int lines = 0;

  int incomingPerSecond = 0;
  int linesPerSecond = 0;

  List<GameItem> games = [
    GameItem(size: GameSize.tiny, cost: 100, income: 5),
    GameItem(size: GameSize.small, cost: 10000, income: 50),
    GameItem(size: GameSize.medium, cost: 1000000, income: 500),
    GameItem(size: GameSize.large, cost: 1000000000, income: 5000),
    GameItem(size: GameSize.aaa, cost: 1000000000000, income: 50000),
  ];

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

  void publishGame(GameSize gameSize) {
    var game = getGame(gameSize);
    if (lines < game.cost) return;

    lines -= game.cost;
    incomingPerSecond += game.income;
  }

  GameItem getGame(GameSize size){
    return games.firstWhere((element) => element.size == size);
  }

  void hireDeveloper(int developerLines) {
    if (money < 1000) return;

    money -= 1000;
    linesPerSecond += developerLines;
  }
}

enum GameSize {tiny, small, medium, large, aaa}

// TODO find better naming
class GameItem{
  GameItem({required this.size, required this.cost, required this.income});

  final GameSize size;
  final int cost;
  final int income;
}
