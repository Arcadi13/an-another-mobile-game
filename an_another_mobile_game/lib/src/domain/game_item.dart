enum GameSize { mod, tiny, small, medium, large, aaa, gtavi }

// TODO find better naming
class GameItem {
  GameItem({required this.size, required this.title, required this.cost, required this.income});

  GameItem.fromJson(Map<String, Object?> json)
      : this(
          size: _gameSizeFromString(json['size']! as String),
          cost: json['cost']! as int,
          income: json['income']! as int,
          title: json['title']! as String,
        );

  final GameSize size;
  final String title;
  final int cost;
  final int income;

  Map<String, Object?> toJson (){
    return {
      'size': _stringFromGameSize(size),
      'cost': cost,
      'income': income,
      'title': title,
    };
  }

  static GameSize _gameSizeFromString(String size) {
    return GameSize.values.firstWhere((e) =>
        e.toString().toLowerCase().split('.').last == size.toLowerCase());
  }

  static String _stringFromGameSize(GameSize size) {
    return size.toString().toLowerCase().split('.').last;
  }
}
