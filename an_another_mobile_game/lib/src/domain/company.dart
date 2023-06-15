import 'department.dart';
import 'department_size.dart';
import 'developer.dart';
import 'game_item.dart';
import 'office.dart';

class CompanyRecord {
  CompanyRecord({
    required this.office,
    required this.departments,
    required this.games,
  });

  CompanyRecord.fromJson(Map<String, dynamic> json)
      : this(
          games: List<GameItem>.from(
              json['games']!.map((game) => GameItem.fromJson(game))),
          office: Office.fromJson(json['office']!),
          departments: List<Department>.from(json['departments']!.map(
              (department) => Department.fromRecord(
                  DepartmentRecord.fromJson(department)))),
        );

  CompanyRecord.fromCompany(Company company)
      : this(
            office: company.office,
            departments: company.departments,
            games: company.publishedGames);

  final Office office;
  final List<Department> departments;
  final List<GameItem> games;

  Map<String, Object?> toJson() {
    return {
      'office': office.toJson(),
      'departments': departments
          .map((department) =>
              DepartmentRecord.fromDepartment(department).toJson())
          .toList(),
      'games': games.map((game) => game.toJson()).toList(),
    };
  }
}

class Company {
  Company();

  Company.fromRecord(CompanyRecord record) {
    office = record.office;
    departments = record.departments;
    publishedGames = record.games;
  }

  late Office office;
  List<Department> departments = [];
  List<GameItem> publishedGames = [];

  bool canDepartmentHire(DeveloperType developerType) {
    var department = _getDepartment(developerType);
    if (department == null) return false;

    return department.size > department.hired;
  }

  void hireDeveloper(DeveloperType developerType) {
    var department = _getDepartment(developerType);
    department?.hireDeveloper();
  }

  int getDepartmentProductivity(DeveloperType developerType) {
    var department = _getDepartment(developerType);
    if (department == null) return 0;

    return (department.hired * department.productivityMultiplier).round();
  }

  void increaseDepartmentProductivity(
      DeveloperType developerType, double multiplier) {
    var department = _getDepartment(developerType);
    department?.productivityIncreased(multiplier);
  }

  void updateOffice(Office office) {
    for (var departmentSize in office.departmentSizes) {
      _updateDepartmentSize(departmentSize);
    }
    this.office = office;
  }

  void publishGame(GameItem game) => publishedGames.add(game);

  Department? _getDepartment(DeveloperType developerType) {
    if (!departments
        .any((department) => department.developerType == developerType)) {
      return null;
    }

    return departments.firstWhere((dep) => dep.developerType == developerType);
  }

  void _updateDepartmentSize(DepartmentSize departmentSize) {
    var department = _getDepartment(departmentSize.developerType);

    if(department == null){
      departments.add(Department(departmentSize.developerType, departmentSize.size));
      return;
    }

    department?.expandSize(departmentSize.size);
  }
}
