import 'developer.dart';

class Enhancement {
  Enhancement(
      {required this.developerType,
      required this.multiplier,
      required this.cost,
      required this.name,
      required this.description});

  Enhancement.fromJson(Map<String, Object?> json):this(
    developerType: _developerTypeFromString(json['developerType']! as String),
    multiplier: double.parse(json['multiplier']!.toString()),
    cost: json['cost']! as int,
    name: json['name']! as String,
    description: json['description']! as String,
  );

  final DeveloperType? developerType;
  final double multiplier;
  final int cost;
  final String name;
  final String description;

  bool acquired = false;

  void enhancementAcquired() => acquired = true;

  static DeveloperType? _developerTypeFromString(String size) {
    if(size == 'none') return null;

    return DeveloperType.values.firstWhere((e) =>
    e.toString().toLowerCase().split('.').last == size.toLowerCase());
  }

  static String _stringFromDeveloperType(DeveloperType size) {
    return size.toString().toLowerCase().split('.').last;
  }
}
