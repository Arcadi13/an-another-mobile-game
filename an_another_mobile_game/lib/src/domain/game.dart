import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

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

  GameRecord.fromGame(Game game)
      : this(
          money: game.money,
          lines: game.lines,
          incomingPerSecond: game.incomingPerSecond,
          linesPerSecond: game.linesPerSecond,
          games: game.games,
          offices: game.offices,
          developers: game.developers,
          enhancements: game.enhancements,
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
      'offices': offices.map((office) => office.toJson()).toList(),
      'developers': developers.map((developer) => developer.toJson()).toList(),
      'enhancements': enhancements.map((enhancement) => enhancement.toJson()).toList(),
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

    games.sort((a, b) => a.cost.compareTo(b.cost));
    enhancements.sort((a, b) => a.cost.compareTo(b.cost));
    improveOffice(OfficeType.home);
  }

  int money = 0;
  int lines = 0;
  int incomingPerSecond = 0;
  int linesPerSecond = 0;
  double playerProductivity = 1;
  List<GameItem> games = [];
  List<Office> offices = [];
  List<OfficeType> boughtOffices = [];
  List<Developer> developers = [];
  List<Enhancement> enhancements = [];
  List<Enhancement> acquiredEnhancements = [];
  Company company = Company();

  Stream<Game> tick() {
    return Stream.periodic(const Duration(milliseconds: 100), (tick) => this);
  }

  void timer() =>
      Timer.periodic(const Duration(seconds: 1), (timer) => _incomePerSecond());

  void saveData() =>
      Timer.periodic(const Duration(minutes: 1), (timer) => _saveGame());

  void writeLine() {
    lines += playerProductivity.round();
  }

  void publishGame(GameSize gameSize) {
    var game = _getGame(gameSize);
    if (lines < game.cost) return;

    lines -= game.cost;
    company.publishGame(game);
    _calculateIncomingPerSecond();
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
    if (money < enhancement.cost ||
        acquiredEnhancements.contains(enhancement)) {
      return;
    }

    money -= enhancement.cost;
    acquiredEnhancements.add(enhancement);
    if (enhancement.type == EnhancementType.developer) {
      company.increaseDepartmentProductivity(
          enhancement.developerType!, enhancement.multiplier);
    }

    if (enhancement.type == EnhancementType.player) {
      playerProductivity *= enhancement.multiplier;
      return;
    }
    _calculateLinesPerSecond();
  }

  void improveOffice(OfficeType type) {
    var office = offices.firstWhere((element) => element.type == type);
    if (boughtOffices.contains(type) || money < office.cost) return;

    money -= office.cost;
    boughtOffices.add(type);
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

    boughtOffices.removeRange(0, boughtOffices.length);
    acquiredEnhancements.removeRange(0, acquiredEnhancements.length);

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

    linesPerSecond =
        (departmentsProductivity * genericEnhancementsMultiplier).round();
  }

  void _calculateIncomingPerSecond() {
    var incoming = 0;
    for (GameItem game in company.publishedGames) {
      incoming += game.income;
    }

    incomingPerSecond = incoming;
  }

  GameItem _getGame(GameSize size) {
    return games.firstWhere((element) => element.size == size);
  }

  _incomePerSecond() {
    money += incomingPerSecond;
    lines += linesPerSecond;
  }

  double _getGenericEnhancementsMultiplier() {
    var multiplier = 1.0;

    for (Enhancement enhancement in enhancements) {
      if (enhancement.type != EnhancementType.generic ||
          !acquiredEnhancements.contains(enhancement)) {
        continue;
      }

      multiplier *= enhancement.multiplier;
    }

    return multiplier;
  }

  Future<void> _saveGame() async {
    final gameRef = FirebaseFirestore.instance
        .collection('users')
        .withConverter<GameRecord>(
            fromFirestore: (snapshot, _) =>
                GameRecord.fromJson(snapshot.data()!),
            toFirestore: (game, _) => game.toJson());

    await gameRef.doc('test').set(GameRecord.fromGame(this));
  }
}
