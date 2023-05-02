import 'developer.dart';

class DepartmentSize {
  DepartmentSize({required this.developerType, required this.size});

  DepartmentSize.fromJson(Map<String, dynamic> json)
      : this(
          developerType: _developerTypeFromString(json['developerType']! as String),
          size: json['size']! as int,
        );

  final DeveloperType developerType;
  final int size;

  static DeveloperType _developerTypeFromString(String size) {
    return DeveloperType.values.firstWhere((e) =>
        e.toString().toLowerCase().split('.').last == size.toLowerCase());
  }

  static String _stringFromDeveloperType(DeveloperType size) {
    return size.toString().toLowerCase().split('.').last;
  }
}
