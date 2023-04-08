import 'dart:async';

class Game {
  Game() {
    improveOffice(OfficeType.home);
  }

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

  List<Office> availableOffices = [
    Office(0, OfficeType.home, [DepartmentSize(DeveloperType.fullstack, 1)]),
    Office(10000, OfficeType.garage, [
      DepartmentSize(DeveloperType.fullstack, 5),
      DepartmentSize(DeveloperType.artist, 1)
    ])
  ];

  late Office office;

  List<Developer> hiring = [
    Developer(DeveloperType.fullstack, 5, 1000, 'Fullstack developer',
        'Increase your lines per second in 5'),
    Developer(DeveloperType.artist, 10, 2000, 'General artist',
        'Increase your lines per second in 10'),
  ];

  List<Department> departments = [Department(DeveloperType.fullstack, 1, 0, 1),
    Department(DeveloperType.artist, 0, 0, 1),];

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
    var developer = hiring.firstWhere((dev) => dev.type == developerType);
    var department =
        departments.firstWhere((dep) => dep.developerType == developerType);

    if (money < developer.cost || department.hired >= department.size) {
      return;
    }
    department.hireDeveloper();
    money -= developer.cost;
    _calculateLinesPerSecond();
  }

  void toolBought() {
    if (money < 1000) return;

    money -= 1000;
    departments.first.productivityIncreased();
    _calculateLinesPerSecond();
  }

  void improveOffice(OfficeType type) {
    var newOffice =
        availableOffices.firstWhere((element) => element.type == type);
    if (newOffice.bought || money < newOffice.cost) return;

    money -= newOffice.cost;
    newOffice.bought = true;
    _updateTeam(newOffice.departmentSizes);
    office = newOffice;
  }

  void _updateTeam(List<DepartmentSize> sizes) {
    for (var department in departments) {
      if (!sizes.any(
          (element) => element.developerType == department.developerType)) {
        continue;
      }

      var size = sizes
          .firstWhere(
              (element) => element.developerType == department.developerType)
          .size;

      department.expandSize(size);
    }
  }

  void _calculateLinesPerSecond() {
    var x = 0;
    for (Department department in departments) {
      x += hiring
              .firstWhere((element) => element.type == department.developerType)
              .productivity *
          department.hired *
          department.productivityMultiplier;
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
      this.developerType, this.size, this.hired, this.productivityMultiplier);

  final DeveloperType developerType;

  int size;
  int hired;
  int productivityMultiplier;

  void hireDeveloper() => hired++;

  void productivityIncreased() => productivityMultiplier++;

  void expandSize(int newSize) => size = newSize;
}
