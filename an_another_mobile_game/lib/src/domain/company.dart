import 'department.dart';
import 'department_size.dart';
import 'developer.dart';
import 'game_item.dart';
import 'office.dart';

class Company {
  Company() {
    departments = [
      Department(DeveloperType.fullstack),
      Department(DeveloperType.artist),
    ];
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
    department?.expandSize(departmentSize.size);
  }
}
