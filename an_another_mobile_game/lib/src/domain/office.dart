import 'department_size.dart';

enum OfficeType { home, garage, coworking, floor, building, skyScarper, city }

class Office {
  Office(
      {required this.cost, required this.type, required this.departmentSizes});

  Office.fromJson(Map<String, dynamic> json)
      : this(
          cost: json['cost']! as int,
          type:  _officeTypeFromString(json['type']! as String),
          departmentSizes: List<DepartmentSize>.from(
              json['departmentSizes'].map((e) => DepartmentSize.fromJson(e))),
        );

  final int cost;
  final OfficeType type;
  final List<DepartmentSize> departmentSizes;

  bool bought = false;

  static OfficeType _officeTypeFromString(String type) {
    return OfficeType.values.firstWhere((e) =>
    e.toString().toLowerCase().split('.').last == type.toLowerCase());
  }

  static String _stringFromOfficeType(OfficeType size) {
    return size.toString().toLowerCase().split('.').last;
  }
}
