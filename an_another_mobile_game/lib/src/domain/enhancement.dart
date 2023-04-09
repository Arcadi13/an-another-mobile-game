import 'developer.dart';

class Enhancement {
  Enhancement(this.developerType, this.multiplier, this.cost, this.name, this.description);

  final DeveloperType developerType;
  final int multiplier;
  final int cost;
  final String name;
  final String description;

  bool acquired = false;

  void enhancementAcquired() => acquired = true;
}
