class Game {
  int money = 2000;
  int lines = 0;

  int incomingPerSecond = 0;
  int linesPerSecond = 0;

  int teamSize = 0;
  int maxTeamSize = 1;

  List<GameItem> games = [
    GameItem(size: GameSize.tiny, cost: 100, income: 5),
    GameItem(size: GameSize.small, cost: 10000, income: 50),
    GameItem(size: GameSize.medium, cost: 1000000, income: 500),
    GameItem(size: GameSize.large, cost: 1000000000, income: 5000),
    GameItem(size: GameSize.aaa, cost: 1000000000000, income: 50000),
  ];

  Stream<Game> tick() {
    return Stream.periodic(const Duration(seconds: 1), (tick) => _ticked());
  }

  Game _ticked() {
    money = money + incomingPerSecond;
    lines = lines + linesPerSecond;
    return this;
  }

  void writeLine() {
    lines++;
  }

  void publishGame(GameSize gameSize) {
    var game = _getGame(gameSize);
    if (lines < game.cost) return;

    lines -= game.cost;
    incomingPerSecond += game.income;
  }

  GameItem _getGame(GameSize size){
    return games.firstWhere((element) => element.size == size);
  }

  void hireDeveloper(int developerLines) {
    if (money < 1000 || teamSize >= maxTeamSize) return;

    money -= 1000;
    teamSize++;
    linesPerSecond += developerLines;
  }

  void toolBought() {
    if (money < 1000) return;

    money -= 1000;
    linesPerSecond = 2 * linesPerSecond;
  }

  void improveOffice() {
    if (money < 10000) return;

    money -= 10000;
    maxTeamSize++;
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
