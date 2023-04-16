import 'dart:async';

import 'company.dart';
import 'department_size.dart';
import 'developer.dart';
import 'enhancement.dart';
import 'game_item.dart';
import 'office.dart';

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

  List<Enhancement> enhancements = [
    Enhancement(DeveloperType.fullstack, 2, 1000, 'Engine License',
        'Increase your fullstack developers productivity 100%')
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

  void toolBought(Enhancement enhancement) {
    if (money < enhancement.cost || enhancement.acquired) return;

    money -= enhancement.cost;
    enhancement.enhancementAcquired();
    company.increaseDepartmentProductivity(DeveloperType.fullstack, enhancement.multiplier);
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
