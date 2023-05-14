import 'developer.dart';

class Department {
  Department(this.developerType);

  final DeveloperType developerType;

  int size = 0;
  int hired = 0;
  double productivityMultiplier = 1;

  void hireDeveloper() => hired++;

  void productivityIncreased(double multiplier) => productivityMultiplier *= multiplier;

  void expandSize(int newSize) => size = newSize;
}
