import 'developer.dart';

class DepartmentSize {
  DepartmentSize({required this.developerType, required this.size});

  DepartmentSize.fromJson(Map<String, dynamic> json)
      : this(
          developerType: _developerTypeFromString(json['developerType']! as String),
          size: json['size']! as int,
        );

  Map<String, Object?> toJson (){
    return {
      'developerType': _stringFromDeveloperType(developerType),
      'size': size,
    };
  }

  final DeveloperType developerType;
  final int size;

  static DeveloperType _developerTypeFromString(String size) {
    return DeveloperType.values.firstWhere((e) =>
        e.toString().toLowerCase().split('.').last == size.toLowerCase());
  }

  static String _stringFromDeveloperType(DeveloperType developerType) {
    return developerType.toString().toLowerCase().split('.').last;
  }
}
