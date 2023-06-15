enum DeveloperType {
  fullstack,
  artist,
  uiDesigner,
  gameArtist,
  animator,
  programmer,
  gameDesigner,
  soundEngineer,
  creativeDirector,
  marketing,
  systemDesigner,
  toolDesigner,
  vfxArtist,
  levelDesigner
}

class Developer {
  Developer({
    required this.type,
    required this.productivity,
    required this.cost,
    required this.title,
    required this.description,
  });

  Developer.fromJson(Map<String, Object?> json)
      : this(
          type: _developerTypeFromString(json['type']! as String),
    productivity: json['productivity']! as int,
    cost: json['cost']! as int,
    title: json['title']! as String,
    description: json['description']! as String,
  );

  Map<String, Object?> toJson (){
    return {
      'type': _stringFromDeveloperType(type),
      'productivity': productivity,
      'cost': cost,
      'title': title,
      'description': description,
    };
  }

  final DeveloperType type;
  final int productivity;
  final int cost;
  final String title;
  final String description;

  static DeveloperType _developerTypeFromString(String size) {
    return DeveloperType.values.firstWhere((e) =>
    e.toString().toLowerCase().split('.').last == size.toLowerCase());
  }

  static String _stringFromDeveloperType(DeveloperType type) {
    return type.toString().toLowerCase().split('.').last;
  }
}
