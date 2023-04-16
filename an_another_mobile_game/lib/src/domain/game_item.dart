enum GameSize { tiny, small, medium, large, aaa }

// TODO find better naming
class GameItem {
  GameItem({required this.size, required this.cost, required this.income});

  final GameSize size;
  final int cost;
  final int income;
}
