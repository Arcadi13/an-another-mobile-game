import 'developer.dart';

enum EnhancementType { developer, generic, player }

class Enhancement {
  Enhancement(
      {required this.developerType,
      required this.type,
      required this.multiplier,
      required this.cost,
      required this.name,
      required this.description});

  Enhancement.fromJson(Map<String, Object?> json)
      : this(
          developerType:
              _developerTypeFromString(json['developerType']! as String),
          type: _enhancementTypeFromString(json['type']! as String),
          multiplier: double.parse(json['multiplier']!.toString()),
          cost: json['cost']! as int,
          name: json['name']! as String,
          description: json['description']! as String,
        );

  final DeveloperType? developerType;
  final EnhancementType type;
  final double multiplier;
  final int cost;
  final String name;
  final String description;

  static DeveloperType? _developerTypeFromString(String size) {
    if (size == 'none') return null;

    return DeveloperType.values.firstWhere((e) =>
        e.toString().toLowerCase().split('.').last == size.toLowerCase());
  }

  static EnhancementType _enhancementTypeFromString(String type) {
    return EnhancementType.values.firstWhere((e) =>
        e.toString().toLowerCase().split('.').last == type.toLowerCase());
  }

  static String _stringFromDeveloperType(DeveloperType size) {
    return size.toString().toLowerCase().split('.').last;
  }
}
