import 'developer.dart';

class DepartmentRecord {
  DepartmentRecord(
      {required this.developerType, required this.size, required this.hired, required this.productivityMultiplier,});

  DepartmentRecord.fromJson(Map<String, dynamic> json)
      : this(
    developerType: _developerTypeFromString(json['developerType']! as String),
    size: json['size']! as int,
    hired: json['hired']! as int,
    productivityMultiplier: json['productivityMultiplier']! as double,
  );

  DepartmentRecord.fromDepartment(Department department) : this(
      developerType: department.developerType,
      size: department.size,
      hired: department.hired,
      productivityMultiplier: department.productivityMultiplier
  );

  Map<String, Object?> toJson() {
    return {
      'developerType': _stringFromDeveloperType(developerType),
      'size': size,
      'hired': hired,
      'productivityMultiplier': productivityMultiplier,
    };
  }

  final DeveloperType developerType;
  final int size;
  final int hired;
  final double productivityMultiplier;

  static DeveloperType _developerTypeFromString(String developerType) {
    return DeveloperType.values.firstWhere((e) =>
    e
        .toString()
        .toLowerCase()
        .split('.')
        .last == developerType.toLowerCase());
  }

  static String _stringFromDeveloperType(DeveloperType developerType) {
    return developerType
        .toString()
        .toLowerCase()
        .split('.')
        .last;
  }
}

class Department {
  Department(this.developerType,  this.size);

  Department.fromRecord(DepartmentRecord record){
    developerType = record.developerType;
    size = record.size;
    hired = record.hired;
    productivityMultiplier = record.productivityMultiplier;
  }

  DeveloperType developerType = DeveloperType.fullstack;
  int size = 0;
  int hired = 0;
  double productivityMultiplier = 1;

  void hireDeveloper() => hired++;

  void productivityIncreased(double multiplier) =>
      productivityMultiplier *= multiplier;

  void expandSize(int newSize) => size = newSize;
}
