import 'dart:async';

class Game {
  Game() {
    improveOffice(OfficeType.home);
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

  List<Office> availableOffices = [
    Office(0, OfficeType.home, [OfficeSpace(DeveloperType.fullstack, 1, 0)]),
    Office(10000, OfficeType.garage, [
      OfficeSpace(DeveloperType.fullstack, 5, 0),
      OfficeSpace(DeveloperType.artist, 1, 0)
    ])
  ];

  late Office office;

  List<Developer> hiring = [
    Developer(DeveloperType.fullstack, 5, 1000, 'Fullstack developer',
        'Increase your lines per second in 5'),
    Developer(DeveloperType.artist, 10, 2000, 'General artist',
        'Increase your lines per second in 10'),
  ];

  List<Developer> team = [];

  Stream<Game> tick() {
    return Stream.periodic(const Duration(milliseconds: 100), (tick) => this);
  }

  void timer() =>
      Timer.periodic(const Duration(seconds: 1), (timer) => _incomePerSecond());

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
    var developer = team.firstWhere((element) => element.type == developerType);
    var space = office.spaces
        .firstWhere((element) => element.developerType == developerType);

    if (money < developer.cost || space.hired >= space.spaces) {
      return;
    }
    space.hireDeveloper();
    money -= developer.cost;
    _calculateLinesPerSecond();
  }

  void toolBought() {
    if (money < 1000) return;

    money -= 1000;
    team.first.increaseMultiplier();
    _calculateLinesPerSecond();
  }

  void improveOffice(OfficeType type) {
    var newOffice =
        availableOffices.firstWhere((element) => element.type == type);
    if (newOffice.bought || money < newOffice.cost) return;

    money -= newOffice.cost;
    newOffice.bought = true;
    _updateTeam(newOffice.spaces);
    office = newOffice;
  }

  void _updateTeam(List<OfficeSpace> spaces) {
    for (var space in spaces) {
      var developer = hiring
          .firstWhere((developer) => developer.type == space.developerType);
      if (team.any((element) => element.type == developer.type)) {
        continue;
      }
      team.add(developer);
    }
  }

  void _calculateLinesPerSecond() {
    var x = 0;
    for (Developer developer in team) {
      x += developer.productivity *
          office.spaces
              .firstWhere((element) => element.developerType == developer.type)
              .hired *
          developer.multiplier;
    }

    linesPerSecond = x;
  }

  _incomePerSecond() {
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
      this.type, this.productivity, this.cost, this.title, this.description);

  final DeveloperType type;
  final int productivity;
  final int cost;
  final String title;
  final String description;

  int multiplier = 1;

  void increaseMultiplier() => multiplier++;
}

class Office {
  Office(this.cost, this.type, this.spaces);

  final int cost;
  final OfficeType type;
  final List<OfficeSpace> spaces;

  bool bought = false;
}

enum OfficeType { home, garage, coworking, floor, building, skyScarper, city }

class OfficeSpace {
  OfficeSpace(this.developerType, this.spaces, this.hired);

  final DeveloperType developerType;
  final int spaces;

  int hired;

  void hireDeveloper() => hired++;
}
