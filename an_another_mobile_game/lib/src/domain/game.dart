import 'dart:async';

import 'company.dart';
import 'developer.dart';
import 'enhancement.dart';
import 'game_item.dart';
import 'office.dart';

class GameRecord {
  GameRecord({
    required this.money,
    required this.lines,
    required this.incomingPerSecond,
    required this.linesPerSecond,
    required this.games,
    required this.offices,
    required this.developers,
    required this.enhancements,
  });

  GameRecord.fromJson(Map<String, dynamic> json)
      : this(
          money: json['money']! as int,
          lines: json['lines']! as int,
          incomingPerSecond: json['incomingPerSecond']! as int,
          linesPerSecond: json['linesPerSecond']! as int,
          games: List<GameItem>.from(
              json['games']!.map((game) => GameItem.fromJson(game))),
          offices: List<Office>.from(
              json['offices']!.map((office) => Office.fromJson(office))),
          developers: List<Developer>.from(json['developers']!
              .map((developer) => Developer.fromJson(developer))),
          enhancements: List<Enhancement>.from(json['enhancements']!
              .map((enhancement) => Enhancement.fromJson(enhancement))),
        );

  final int money;
  final int lines;
  final int incomingPerSecond;
  final int linesPerSecond;
  final List<GameItem> games;
  final List<Office> offices;
  final List<Developer> developers;
  final List<Enhancement> enhancements;

  Map<String, Object?> toJson() {
    return {
      'money': money,
      'lines': lines,
      'incomingPerSecond': incomingPerSecond,
      'linesPerSecond': linesPerSecond,
      'games': games.map((game) => game.toJson()).toList(),
    };
  }
}

class Game {

  Game.fromRecord(GameRecord record) {
    money = record.money;
    lines = record.lines;
    incomingPerSecond = record.incomingPerSecond;
    linesPerSecond = record.linesPerSecond;
    games = record.games;
    offices = record.offices;
    developers = record.developers;
    enhancements = record.enhancements;

    improveOffice(OfficeType.home);
  }

  int money = 0;
  int lines = 0;
  int incomingPerSecond = 0;
  int linesPerSecond = 0;
  List<GameItem> games = [];
  List<Office> offices = [];
  List<Developer> developers = [];
  List<Enhancement> enhancements = [];
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
    if(enhancement.developerType != null){
      company.increaseDepartmentProductivity(
          enhancement.developerType!, enhancement.multiplier);
    }
    _calculateLinesPerSecond();
  }

  void improveOffice(OfficeType type) {
    var office = offices.firstWhere((element) => element.type == type);
    if (office.bought || money < office.cost) return;

    money -= office.cost;
    office.bought = true;
    company.updateOffice(office);
  }

  int companyValue() {
    return incomingPerSecond * 10;
  }

  void sellCompany() {
    money = 0;
    lines = 0;
    incomingPerSecond = 0;
    linesPerSecond = 0;

    for (Office office in offices) {
      office.bought = false;
    }

    company = Company();
    improveOffice(OfficeType.home);
  }

  void _calculateLinesPerSecond() {
    var departmentsProductivity = 0;
    for (Developer developer in developers) {
      departmentsProductivity += developer.productivity *
          company.getDepartmentProductivity(developer.type);
    }

    var genericEnhancementsMultiplier = _getGenericEnhancementsMultiplier();

    linesPerSecond = (departmentsProductivity * genericEnhancementsMultiplier).round();
  }

  _incomePerSecond() {
    money += incomingPerSecond;
    lines += linesPerSecond;
  }

  double _getGenericEnhancementsMultiplier() {
    var multiplier = 1.0;

    for (Enhancement enhancement in enhancements){
      if(enhancement.developerType != null || !enhancement.acquired) continue;

      multiplier *= enhancement.multiplier;
    }

    return multiplier;
  }
}
