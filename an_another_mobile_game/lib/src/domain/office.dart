import 'department_size.dart';

enum OfficeType { home, garage, coworking, floor, building, skyScarper, city }

class Office {
  Office(this.cost, this.type, this.departmentSizes);

  final int cost;
  final OfficeType type;
  final List<DepartmentSize> departmentSizes;

  bool bought = false;
}
