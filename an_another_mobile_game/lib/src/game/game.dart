import 'dart:async';

import 'package:an_another_mobile_game/src/game/company.dart';

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

  List<Office> offices = [
    Office(0, OfficeType.home, [DepartmentSize(DeveloperType.fullstack, 1)]),
    Office(10000, OfficeType.garage, [
      DepartmentSize(DeveloperType.fullstack, 5),
      DepartmentSize(DeveloperType.artist, 1)
    ])
  ];

  List<Developer> developers = [
    Developer(DeveloperType.fullstack, 5, 1000, 'Fullstack developer',
        'Increase your lines per second in 5'),
    Developer(DeveloperType.artist, 10, 2000, 'General artist',
        'Increase your lines per second in 10'),
  ];

  Company company = Company();

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
    var developer = developers.firstWhere((dev) => dev.type == developerType);

    if (money < developer.cost || !company.canDepartmentHire(developerType)) {
      return;
    }

    money -= developer.cost;
    company.hireDeveloper(developerType);
    _calculateLinesPerSecond();
  }

  void toolBought() {
    if (money < 1000) return;

    money -= 1000;
    company.increaseDepartmentProductivity(DeveloperType.fullstack, 1);
    _calculateLinesPerSecond();
  }

  void improveOffice(OfficeType type) {
    var office = offices.firstWhere((element) => element.type == type);
    if (office.bought || money < office.cost) return;

    money -= office.cost;
    office.bought = true;
    company.updateOffice(office);
  }

  void _calculateLinesPerSecond() {
    var x = 0;
    for (Developer developer in developers) {
      x += developer.productivity *
          company.getDepartmentProductivity(developer.type);
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
  Office(this.cost, this.type, this.departmentSizes);

  final int cost;
  final OfficeType type;
  final List<DepartmentSize> departmentSizes;

  bool bought = false;
}

class DepartmentSize {
  DepartmentSize(this.developerType, this.size);

  final DeveloperType developerType;
  final int size;
}

enum OfficeType { home, garage, coworking, floor, building, skyScarper, city }

class Department {
  Department(
      this.developerType);

  final DeveloperType developerType;

  int size = 0;
  int hired = 0;
  int productivityMultiplier = 1;

  void hireDeveloper() => hired++;

  void productivityIncreased() => productivityMultiplier++;

  void expandSize(int newSize) => size = newSize;
}
