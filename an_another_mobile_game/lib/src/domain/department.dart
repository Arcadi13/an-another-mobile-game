import 'developer.dart';

class Department {
  Department(this.developerType);

  final DeveloperType developerType;

  int size = 0;
  int hired = 0;
  int productivityMultiplier = 1;

  void hireDeveloper() => hired++;

  void productivityIncreased() => productivityMultiplier++;

  void expandSize(int newSize) => size = newSize;
}
