import 'dart:async';

class Game {
  Game() {
    team.add(HiredDeveloper(
        hiring.firstWhere((element) => element.type == DeveloperType.fullstack),
        1,
        0));
  }

  int money = 40000;
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

  List<Developer> hiring = [
    Developer(
        type: DeveloperType.fullstack,
        productivity: 5,
        cost: 1000,
        title: 'Fullstack developer',
        description: 'Increase your lines per second in 5'),
    Developer(
        type: DeveloperType.artist,
        productivity: 10,
        cost: 2000,
        title: 'General artist',
        description: 'Increase your lines per second in 10'),
  ];

  List<HiredDeveloper> team = [];

  Stream<Game> tick() {
    return Stream.periodic(const Duration(milliseconds: 100), (tick) => this);
  }

  void timer() => Timer.periodic(const Duration(seconds: 1), (timer) => _increasePerSecond());

  void writeLine() {
    lines++;
  }

  void publishGame(GameSize gameSize) {
    var game = _getGame(gameSize);
    if (lines < game.cost) return;

    lines -= game.cost;
    incomingPerSecond += game.income;
  }

  GameItem _getGame(GameSize size) {
    return games.firstWhere((element) => element.size == size);
  }

  void hireDeveloper(DeveloperType developerType) {
    var developer =
        team.firstWhere((element) => element.developer.type == developerType);
    if (money < developer.developer.cost || !developer.hireDeveloper()) return;

    money -= developer.developer.cost;
    _calculateLinesPerSecond();
  }

  void toolBought() {
    if (money < 1000) return;

    money -= 1000;
    team.first.increaseMultiplier();
    _calculateLinesPerSecond();
  }

  void improveOffice() {
    if (money < 10000) return;

    money -= 10000;
    team.first.increaseTeamSize();
  }

  void _calculateLinesPerSecond() {
    var x = 0;
    for (HiredDeveloper developer in team) {
      x += developer.developer.productivity * developer.hired * developer.multiplier;
    }

    linesPerSecond = x;
  }

  _increasePerSecond() {
    money += incomingPerSecond;
    lines += linesPerSecond;
  }
}

enum GameSize { tiny, small, medium, large, aaa }

// TODO find better naming
class GameItem {
  GameItem({required this.size, required this.cost, required this.income});

  final GameSize size;
  final int cost;
  final int income;
}

enum DeveloperType {
  fullstack,
  artist,
  uiDesigner,
  gameArtist,
  animator,
  programmer,
  gameDesigner,
  soundEngineer,
  creativeDirector,
  marketing,
  systemDesigner,
  toolDesigner,
  vfxArtist,
  levelDesigner
}

class Developer {
  Developer(
      {required this.type,
      required this.productivity,
      required this.cost,
      required this.title,
      required this.description});

  final DeveloperType type;
  final int productivity;
  final int cost;
  final String title;
  final String description;
}

class HiredDeveloper {
  HiredDeveloper(this.developer, this.teamSize, this.hired);

  final Developer developer;
  int teamSize;
  int hired;
  int multiplier = 1;

  bool hireDeveloper() {
    if (hired >= teamSize) return false;

    hired++;
    return true;
  }

  void increaseTeamSize() {
    teamSize++;
  }

  void increaseMultiplier() {
    multiplier++;
  }
}
