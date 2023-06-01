import 'department_size.dart';

enum OfficeType { home, garage, coworking, floor, building, skyScarper, city }

class Office {
  Office(
      {required this.cost,
      required this.title,
      required this.description,
      required this.type,
      required this.departmentSizes});

  Office.fromJson(Map<String, dynamic> json)
      : this(
          cost: json['cost']! as int,
          type: _officeTypeFromString(json['type']! as String),
          title: json['title']! as String,
          description: json['description']! as String,
          departmentSizes: List<DepartmentSize>.from(
              json['departmentSizes'].map((e) => DepartmentSize.fromJson(e))),
        );

  Map<String, Object?> toJson (){
    return {
      'type': _stringFromOfficeType(type),
      'cost': cost,
      'title': title,
      'description': description,
      'departmentSizes': departmentSizes.map((departmentSize) => departmentSize.toJson()).toList(),
    };
  }

  final int cost;
  final OfficeType type;
  final String title;
  final String description;
  final List<DepartmentSize> departmentSizes;

  static OfficeType _officeTypeFromString(String type) {
    return OfficeType.values.firstWhere((e) =>
        e.toString().toLowerCase().split('.').last == type.toLowerCase());
  }

  static String _stringFromOfficeType(OfficeType type) {
    return type.toString().toLowerCase().split('.').last;
  }
}
